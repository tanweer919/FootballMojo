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

void main() async {
  final ThemeData theme = ThemeData(
      primaryColor: Color(0xFF50C878), primaryColorDark: Color(0XFFA0A5AA));
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  final leagueName = await LocalStorage.getString('leagueName');
  User currentUser = null;
  FirebaseService firebaseService = locator<FirebaseService>();
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();
  final result = await DataConnectionChecker().hasConnection;
  if (result) {
    await _remoteConfigService.initialise();
    currentUser = await firebaseService.getCurrentUser();
  }

  AppProvider appProvider =
      locator<AppProvider>(param1: leagueName, param2: currentUser);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => appProvider,
      )
    ],
    child: FlutterEasyLoading(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: WillPopScope(
            onWillPop: () => Future.value(false),
            child: result ? Start() : NoInternetScreen()),
        onGenerateRoute: Router().generateRoutes,
        navigatorObservers: [HeroController()],
      ),
    ),
  ));
}
