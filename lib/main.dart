import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'helper/CustomRouter.dart';
import 'commons/BottomNavbar.dart';
void main() {
  GlobalKey<NavigatorState> navigator = new GlobalKey<NavigatorState>();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(0),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigator,
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        builder: (context, child) {
          return new Scaffold(
              body: child,
              bottomNavigationBar:BottomNavbar(
                navigatorKey: navigator,
              ),
              resizeToAvoidBottomPadding: false
          );
        },
        onGenerateRoute: Router().generateRoutes,
      ),
    )
  );
}