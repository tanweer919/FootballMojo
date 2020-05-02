import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'helper/CustomRouter.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(0),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        onGenerateRoute: Router().generateRoutes,
      ),
    )
  );
}