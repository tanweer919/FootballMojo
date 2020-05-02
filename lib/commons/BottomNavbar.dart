import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_icons.dart';
import '../Provider/AppProvider.dart';
class BottomNavbar extends StatelessWidget {
  static final _bottomNavBarStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  final List<BottomNavigationBarItem> bottomNavbarItems = [
    BottomNavigationBarItem(
      activeIcon: Icon(MyFlutterApp.home__1_, color: Colors.orange,),
      icon: Icon(MyFlutterApp.home__1_),
      title: Text('Home', style: _bottomNavBarStyle,)
    ),
    BottomNavigationBarItem(
        activeIcon: Icon(MyFlutterApp.score, color: Colors.orange,),
        icon: Icon(MyFlutterApp.score),
        title: Text('Score', style: _bottomNavBarStyle,)
    ),
    BottomNavigationBarItem(
        activeIcon: Icon(MyFlutterApp.news, color: Colors.orange,),
        icon: Icon(MyFlutterApp.news),
        title: Text('News', style: _bottomNavBarStyle,)
    )
  ];
  final List<String> routes = ['/home', '/score', '/news'];
  Widget build(BuildContext context){
    final appProvider = Provider.of<AppProvider>(context);
    return BottomNavigationBar(
      items: bottomNavbarItems,
      onTap: (int index) {
        appProvider.navbarIndex = index;
        Navigator.of(context).pushReplacementNamed(routes[index]);
      },
      currentIndex: appProvider.navbarIndex,
    );
  }
}