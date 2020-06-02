import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'services/CustomRouter.dart';
import 'services/GetItLocator.dart';
import 'Provider/AppProvider.dart';

void main() {
  setupLocator();
  final ThemeData theme = ThemeData(
    primaryColor: Color(0xFF50C878),
    primaryColorDark: Color(0XFFA0A5AA)
  );
  AppProvider appProvider = locator<AppProvider>();

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
        home: HomeScreen(),
        onGenerateRoute: Router().generateRoutes,
        navigatorObservers: [
          HeroController()
        ],
      ),
    )
  );
}