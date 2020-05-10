import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_icons.dart';
import '../Provider/AppProvider.dart';
class BottomNavbar extends StatelessWidget {
  static final _bottomNavBarStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  final navigatorKey;
  BottomNavbar({this.navigatorKey});
  final List<String> routes = ['/home', '/score', '/news', '/login'];
  final List<Color> backgroundColors = [Colors.blueAccent, Colors.orange, Colors.red, Colors.green];
  Widget build(BuildContext context){
    final appProvider = Provider.of<AppProvider>(context);
    return CurvedNavigationBar(
      height: 55.0,
      backgroundColor: Colors.transparent,
      color: Colors.orange,
      animationDuration: Duration(milliseconds: 500),
      items: <Widget>[
        Icon(MyFlutterApp.home__1_, size: 25, color: Colors.white,),
        Icon(MyFlutterApp.score, size: 25, color: Colors.white,),
        Icon(MyFlutterApp.news, size: 25, color: Colors.white,),
        Icon(Icons.account_circle, size: 25, color: Colors.white,)
      ],
      onTap: (int index) {
        appProvider.navbarIndex = index;
        navigatorKey.currentState.pushReplacementNamed(routes[index]);
      },
    );
  }
}