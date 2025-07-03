import 'package:sportsmojo/models/User.dart';
import 'Provider/AppProvider.dart';
import 'services/CustomRouter.dart';
import 'services/GetItLocator.dart';
import 'services/LocalStorage.dart';
import 'services/FirebaseService.dart';
import 'services/RemoteConfigService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'services/NetworkStatusService.dart';
import 'services/FirebaseMessagingService.dart';
import 'Provider/ThemeProvider.dart';
import 'services/AnalyticsService.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:developer' as developer;

///Class containing all the services that needs to be initialised before running the app
class App {
  static late final ThemeProvider themeProvider;
  static late final AppProvider appProvider;
  static late final RouterService routerService;
  static late final NetworkStatusService networkStatusService;
  static late final FirebaseAnalytics analytics;
  static late final bool result;

  static Future<void> initialiseApp() async {
    try {
      developer.log('Starting app initialization...');

      // Setup GetIt Locator
      await setupLocator();
      developer.log('GetIt Locator setup completed');

      // Get user preferences
      final preferences = await Future.wait([
        LocalStorage.getString('leagueName'),
        LocalStorage.getString('notificationEnabled'),
        LocalStorage.getString('appTheme'),
      ]);

      final String? leagueName = preferences[0] ?? 'Premier League';
      final String? notificationEnabledPreference = preferences[1];
      final bool notificationEnabled = notificationEnabledPreference == "yes";
      final String? theme = preferences[2];

      developer.log('User preferences loaded');

      // Initialize services
      final AnalyticsService analyticsService = locator<AnalyticsService>();
      analytics = analyticsService.analytics;
      developer.log('Analytics service initialized');

      final FirebaseService firebaseService = locator<FirebaseService>();
      final RemoteConfigService remoteConfigService =
          locator<RemoteConfigService>();
      final FirebaseMessagingService fcmService =
          locator<FirebaseMessagingService>();
      networkStatusService = locator<NetworkStatusService>();
      routerService = locator<RouterService>();

      developer.log('Core services initialized');

      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      result = !(connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty);

      developer.log('Network status: ${result ? 'Connected' : 'Disconnected'}');

      User? currentUser;
      if (result) {
        try {
          // Initialize Firebase services in parallel
          await Future.wait([
            fcmService.initialise(),
            remoteConfigService.initialise(),
          ]);
          developer.log('Firebase services initialized');

          // Get current user
          currentUser = await firebaseService.getCurrentUser();
          developer
              .log('Current user: ${currentUser?.name ?? 'Not logged in'}');
        } catch (e) {
          developer.log(
            'Error initializing Firebase services',
            error: e,
            stackTrace: StackTrace.current,
          );
          // Continue with app initialization even if Firebase services fail
        }
      }

      // Setup providers
      appProvider = locator<AppProvider>(
        param1: {
          'leagueName': leagueName,
          'notificationEnabled': notificationEnabled,
        },
        param2: currentUser,
      );

      themeProvider = locator<ThemeProvider>(
        param1: theme == "dark" ? AppTheme.Dark : AppTheme.Light,
      );

      developer.log('App initialization completed successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error during app initialization',
        error: e,
        stackTrace: stackTrace,
      );

      // Set default values if initialization fails
      result = false;
      themeProvider = locator<ThemeProvider>(param1: AppTheme.Light);
      appProvider = locator<AppProvider>(
        param1: {
          'leagueName': 'Premier League',
          'notificationEnabled': false,
        },
        param2: null,
      );

      developer.log('Default values set after initialization failure');
    }
  }
}
