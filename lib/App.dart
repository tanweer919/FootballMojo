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

///Class containing all the services that needs to be initialised before running the app
class App {
  static late final ThemeProvider themeProvider;
  static late final AppProvider appProvider;
  static late final RouterService routerService;
  static late final NetworkStatusService networkStatusService;
  static late final FirebaseAnalytics analytics;
  static late final bool result;

  static Future initialiseApp() async {
    //Setup GetIt Locator
    await setupLocator();

    //Get league name 
    final String? leagueName = await LocalStorage.getString('leagueName') ?? 'Premier League';
    //Get notification Preference
    final String? notificationEnabledPreference =
        await LocalStorage.getString('notificationEnabled');
    final bool notificationEnabled = notificationEnabledPreference == "yes";

    //Initial 
    User? currentUser = null;

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
    List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    // Consider online if it's not .none and not empty
    result = !(connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty);


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
    final String? _theme = await LocalStorage.getString('appTheme');

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
