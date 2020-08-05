import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'start.dart';
import 'package:provider/provider.dart';
import 'screens/NoInternetScreen.dart';
import 'services/NetworkStatusService.dart';
import 'Provider/ThemeProvider.dart';
import 'App.dart';

void main() async {
  final ThemeData lightTheme = ThemeData(
      primaryColor: Color(0xFF50C878),
      primaryColorDark: Color(0X8A000000),
      brightness: Brightness.light);
  final ThemeData darkTheme = ThemeData(
      primaryColor: Color(0xFF54B2FB),
      primaryColorDark: Color(0XFFD1D1D1),
      brightness: Brightness.dark);

  WidgetsFlutterBinding.ensureInitialized();
  await App.initialiseApp();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => App.appProvider,
      ),
      StreamProvider<NetworkStatus>(
        create: (context) =>
            App.networkStatusService.networkStatusController.stream,
      ),
      ChangeNotifierProvider(
        create: (context) => App.themeProvider,
      )
    ],
    child: FlutterEasyLoading(
      child: Consumer<ThemeProvider>(
        builder: (context, model, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: model.appTheme == AppTheme.Light
              ? ThemeMode.light
              : ThemeMode.dark,
          navigatorKey: App.routerService.navigationKey,
          home: WillPopScope(
              onWillPop: () => Future.value(false),
              child: App.result ? Start() : NoInternetScreen()),
          onGenerateRoute: App.routerService.generateRoutes,
          navigatorObservers: [
            HeroController(),
            FirebaseAnalyticsObserver(analytics: App.analytics)
          ],
        ),
      ),
    ),
  ));
}
