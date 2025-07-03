import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'dart:developer' as developer;

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    developer.log('Flutter binding initialized');

    // Configure theme
    final ThemeData lightTheme = ThemeData(
      primaryColor: const Color(0xFF50C878),
      primaryColorDark: const Color(0X8A000000),
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF50C878),
        brightness: Brightness.light,
      ),
    );

    final ThemeData darkTheme = ThemeData(
      primaryColor: const Color(0xFF54B2FB),
      primaryColorDark: const Color(0XFFD1D1D1),
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF54B2FB),
        brightness: Brightness.dark,
      ),
    );

    developer.log('Theme configuration completed');

    // Configure error reporting
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = (FlutterErrorDetails details) {
      developer.log(
        'Flutter error caught',
        error: details.exception,
        stackTrace: details.stack,
      );
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    // Initialize app services
    await App.initialiseApp();
    developer.log('App services initialized');

    // Configure EasyLoading
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;

    developer.log('EasyLoading configured');

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => App.appProvider,
          ),
          StreamProvider<NetworkStatus>(
            create: (context) =>
                App.networkStatusService.networkStatusController.stream,
            initialData: NetworkStatus.Offline,
          ),
          ChangeNotifierProvider(
            create: (context) => App.themeProvider,
          ),
        ],
        child: FlutterEasyLoading(
          child: Consumer<ThemeProvider>(
            builder: (context, model, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Football Mojo',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: model.appTheme == AppTheme.Light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              navigatorKey: App.routerService.navigationKey,
              home: WillPopScope(
                onWillPop: () => Future.value(false),
                child: App.result ? const Start() : const NoInternetScreen(),
              ),
              onGenerateRoute: App.routerService.generateRoutes,
              navigatorObservers: [
                HeroController(),
                FirebaseAnalyticsObserver(analytics: App.analytics),
              ],
            ),
          ),
        ),
      ),
    );
    developer.log('App started successfully');
  } catch (e, stackTrace) {
    developer.log(
      'Error during app startup',
      error: e,
      stackTrace: stackTrace,
    );
    // Show error UI
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to start app',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
