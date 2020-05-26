import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'helper/CustomRouter.dart';
import 'screens/FavouriteScreen1.dart';
void main() {
  final ThemeData theme = ThemeData(
    primaryColor: Color(0xFF50C878),
    primaryColorDark: Color(0XFFA0A5AA)
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(0),
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