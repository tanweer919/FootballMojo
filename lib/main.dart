import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'start.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'services/CustomRouter.dart';
import 'services/GetItLocator.dart';
import 'services/LocalStorage.dart';
import 'services/FirebaseService.dart';
import 'services/RemoteConfigService.dart';
void main() async{
  final ThemeData theme = ThemeData(
    primaryColor: Color(0xFF50C878),
    primaryColorDark: Color(0XFFA0A5AA)
  );
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  final leagueName = await LocalStorage.getString('leagueName');
  FirebaseService firebaseService = locator<FirebaseService>();
  final RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  await _remoteConfigService.initialise();
  final currentUser = await firebaseService.getCurrentUser();
  AppProvider appProvider = locator<AppProvider>(param1: leagueName, param2: currentUser);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => appProvider,
        )
      ],
      child: FlutterEasyLoading(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Start(),
          onGenerateRoute: Router().generateRoutes,
          navigatorObservers: [
            HeroController()
          ],
        ),
      ),
    )
  );
}