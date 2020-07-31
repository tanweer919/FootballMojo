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

void main() async {
  final ThemeData lightTheme = ThemeData(
      primaryColor: Color(0xFF50C878),
      primaryColorDark: Color(0X8A000000),
      brightness: Brightness.light);
  final ThemeData darkTheme = ThemeData(
      primaryColor: Color(0xFF1D1D1D),
      primaryColorDark: Color(0XFFF1F1F1),
      brightness: Brightness.dark);

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  final leagueName = await LocalStorage.getString('leagueName');
  User currentUser = null;
  FirebaseService firebaseService = locator<FirebaseService>();
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();
  final NetworkStatusService _networkStatusService =
      locator<NetworkStatusService>();
  final FirebaseMessagingService _fcmService =
      locator<FirebaseMessagingService>();
  final RouterService _routerService = locator<RouterService>();
  final result = await DataConnectionChecker().hasConnection;
  if (result) {
    await _fcmService.initialise();
    await _remoteConfigService.initialise();
    currentUser = await firebaseService.getCurrentUser();
  }

  AppProvider appProvider =
      locator<AppProvider>(param1: leagueName, param2: currentUser);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => appProvider,
      ),
      StreamProvider<NetworkStatus>(
        create: (context) =>
            _networkStatusService.networkStatusController.stream,
      )
    ],
    child: FlutterEasyLoading(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        navigatorKey: _routerService.navigationKey,
        home: WillPopScope(
            onWillPop: () => Future.value(false),
            child: result ? Start() : NoInternetScreen()),
        onGenerateRoute: _routerService.generateRoutes,
        navigatorObservers: [HeroController()],
      ),
    ),
  ));
}
