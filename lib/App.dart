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

///Class containing all the services that needs to be initialised before running the app
class App {
  static ThemeProvider themeProvider;
  static AppProvider appProvider;
  static RouterService routerService;
  static NetworkStatusService networkStatusService;
  static FirebaseAnalytics analytics;
  static bool result;

  static Future initialiseApp() async {
    //Setup GetIt Locator
    await setupLocator();

    //Get league name 
    final leagueName = await LocalStorage.getString('leagueName');
    //Get notification Preference
    final notificationEnabledPreference =
        await LocalStorage.getString('notificationEnabled');
    final bool notificationEnabled = notificationEnabledPreference == null ||
            notificationEnabledPreference == "yes"
        ? true
        : false;

    //Initial 
    User currentUser = null;

    //Analytics Service
    final AnalyticsService analyticsService = locator<AnalyticsService>();
    analytics = analyticsService.analytics;

    //Firebase Service
    FirebaseService firebaseService = locator<FirebaseService>();

    //Firebase remote config service
    final RemoteConfigService _remoteConfigService =
        locator<RemoteConfigService>();

    //Network connectivity service
    networkStatusService = locator<NetworkStatusService>();

    //Firebase cloud messaging service
    final FirebaseMessagingService _fcmService =
        locator<FirebaseMessagingService>();

    //Router service
    routerService = locator<RouterService>();

    //Check current connection status
    result = await DataConnectionChecker().hasConnection;

    //If network coonectivity is present
    if (result) {
      //Initialise Firebase cloud messaging
      await _fcmService.initialise();
      //Initialise Firebase remote config
      await _remoteConfigService.initialise();
      //Get current user from firebase
      currentUser = await firebaseService.getCurrentUser();
    }

    //Get theme preference
    final _theme = await LocalStorage.getString('appTheme');

    //Setup app global state provider
    appProvider = locator<AppProvider>(param1: {
      'leagueName': leagueName,
      'notificationEnabled': notificationEnabled
    }, param2: currentUser);

    //Setup theme provider
    themeProvider = locator<ThemeProvider>(
        param1: _theme == "dark" ? AppTheme.Dark : AppTheme.Light);
  }
}
