import 'package:sportsmojo/models/User.dart';
import 'Provider/AppProvider.dart';
import 'services/CustomRouter.dart';
import 'services/GetItLocator.dart';
import 'services/LocalStorage.dart';
import 'services/FirebaseService.dart';
import 'services/RemoteConfigService.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'services/NetworkStatusService.dart';
import 'services/FirebaseMessagingService.dart';
import 'Provider/ThemeProvider.dart';
import 'services/AnalyticsService.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class App {
  static ThemeProvider themeProvider;
  static AppProvider appProvider;
  static RouterService routerService;
  static NetworkStatusService networkStatusService;
  static FirebaseAnalytics analytics;
  static bool result;

  static Future initialiseApp() async {
    await setupLocator();
    final leagueName = await LocalStorage.getString('leagueName');
    final notificationEnabledPreference =
        await LocalStorage.getString('notificationEnabled');
    final bool notificationEnabled = notificationEnabledPreference == null ||
            notificationEnabledPreference == "yes"
        ? true
        : false;
    User currentUser = null;
    final AnalyticsService analyticsService = locator<AnalyticsService>();
    analytics = analyticsService.analytics;
    FirebaseService firebaseService = locator<FirebaseService>();
    final RemoteConfigService _remoteConfigService =
        locator<RemoteConfigService>();
    networkStatusService = locator<NetworkStatusService>();
    final FirebaseMessagingService _fcmService =
        locator<FirebaseMessagingService>();
    routerService = locator<RouterService>();
    result = await DataConnectionChecker().hasConnection;
    if (result) {
      await _fcmService.initialise();
      await _remoteConfigService.initialise();
      currentUser = await firebaseService.getCurrentUser();
    }
    final _theme = await LocalStorage.getString('appTheme');
    appProvider = locator<AppProvider>(param1: {
      'leagueName': leagueName,
      'notificationEnabled': notificationEnabled
    }, param2: currentUser);
    themeProvider = locator<ThemeProvider>(
        param1: _theme == "dark" ? AppTheme.Dark : AppTheme.Light);
  }
}