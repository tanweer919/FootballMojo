import 'package:flutter/material.dart';
import 'start.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'services/CustomRouter.dart';
import 'services/GetItLocator.dart';

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
        home: Start(),
        onGenerateRoute: Router().generateRoutes,
        navigatorObservers: [
          HeroController()
        ],
      ),
    )
  );
}