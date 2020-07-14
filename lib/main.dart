import 'package:flutter/material.dart';
import 'start.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'services/CustomRouter.dart';
import 'services/GetItLocator.dart';
import 'services/LocalStorage.dart';

void main() async{
  setupLocator();
  final ThemeData theme = ThemeData(
    primaryColor: Color(0xFF50C878),
    primaryColorDark: Color(0XFFA0A5AA)
  );
  WidgetsFlutterBinding.ensureInitialized();
  final leagueName = await LocalStorage.getString('leagueName');
  AppProvider appProvider = locator<AppProvider>(param1: leagueName);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => appProvider,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Start(),
        onGenerateRoute: Router().generateRoutes,
        navigatorObservers: [
          HeroController()
        ],
      ),
    )
  );
}