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

  //Setting up theme
  final ThemeData lightTheme = ThemeData(
      primaryColor: Color(0xFF50C878),
      primaryColorDark: Color(0X8A000000),
      brightness: Brightness.light);
  final ThemeData darkTheme = ThemeData(
      primaryColor: Color(0xFF54B2FB),
      primaryColorDark: Color(0XFFD1D1D1),
      brightness: Brightness.dark);

  WidgetsFlutterBinding.ensureInitialized();

  //Initialising all the required services before attaching the app to the screen
  await App.initialiseApp();
  Crashlytics.instance.enableInDevMode = true;
  
  //Setting up Crashlytics to report errors.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MultiProvider(          
    providers: [
      ChangeNotifierProvider( //Provider to provide app global state
        create: (context) => App.appProvider,
      ),
      StreamProvider<NetworkStatus>( //Provider to listen for network connectvity change
        create: (context) =>
            App.networkStatusService.networkStatusController.stream,
      ),
      ChangeNotifierProvider( //Provider for handling theme of the app
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
          navigatorKey: App.routerService.navigationKey, //Navigator key for routing from outside widget tree
          home: WillPopScope(
              onWillPop: () => Future.value(false),
              //Shows either the starting page or no connection page depending on the network connectivity
              child: App.result ? Start() : NoInternetScreen()), 
          onGenerateRoute: App.routerService.generateRoutes, //Setting up router
          navigatorObservers: [
            HeroController(), //Controller for Hero animation
            FirebaseAnalyticsObserver(analytics: App.analytics) //Firebase analytics
          ],
        ),
      ),
    ),
  ));
}
