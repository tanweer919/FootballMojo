import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sportsmojo/models/User.dart';
import 'start.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'services/CustomRouter.dart';
import 'services/GetItLocator.dart';
import 'services/LocalStorage.dart';
import 'services/FirebaseService.dart';
import 'services/RemoteConfigService.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'screens/NoInternetScreen.dart';
import 'services/NetworkStatusService.dart';
import 'services/FirebaseMessagingService.dart';
import 'Provider/ThemeProvider.dart';
import 'services/LocalStorage.dart';
import 'App.dart';

void main() async {
  final ThemeData lightTheme = ThemeData(
      primaryColor: Color(0xFF50C878),
      primaryColorDark: Color(0X8A000000),
      brightness: Brightness.light);
  final ThemeData darkTheme = ThemeData(
      primaryColor: Color(0xFF54B2FB),
      primaryColorDark: Color(0XFFF1F1F1),
      brightness: Brightness.dark);

  WidgetsFlutterBinding.ensureInitialized();
  await App.initialiseApp();

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
          themeMode: model.appTheme == AppTheme.Light ? ThemeMode.light : ThemeMode.dark,
          navigatorKey: App.routerService.navigationKey,
          home: WillPopScope(
              onWillPop: () => Future.value(false),
              child: App.result ? Start() : NoInternetScreen()),
          onGenerateRoute: App.routerService.generateRoutes,
          navigatorObservers: [HeroController()],
        ),
      ),
    ),
  ));
}
