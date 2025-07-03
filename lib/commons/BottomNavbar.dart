import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_icons.dart';
import '../Provider/AppProvider.dart';
import '../Provider/ThemeProvider.dart';

class BottomNavbar extends StatelessWidget {
  final List<String> routes = [
    '/home',
    '/score',
    '/league',
    '/news',
    '/dashboard'
  ];

  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final _bottomNavBarStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: _themeProvider.appTheme == AppTheme.Light
          ? Colors.black
          : Colors.white,
    );

    final List<BottomNavigationBarItem> bottomNavbarItems = [
      BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.home__1_,
              color: Theme.of(context).primaryColor),
          icon: Icon(MyFlutterApp.home__1_),
          label: 'Home'),
      BottomNavigationBarItem(
          activeIcon:
              Icon(MyFlutterApp.score, color: Theme.of(context).primaryColor),
          icon: Icon(MyFlutterApp.score),
          label: 'Matches'),
      BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.football,
              color: Theme.of(context).primaryColor),
          icon: Icon(MyFlutterApp.football),
          label: 'League'),
      BottomNavigationBarItem(
          activeIcon:
              Icon(MyFlutterApp.news, color: Theme.of(context).primaryColor),
          icon: Icon(MyFlutterApp.news),
          label: 'News'),
      BottomNavigationBarItem(
          activeIcon:
              Icon(Icons.settings, color: Theme.of(context).primaryColor),
          icon: Icon(Icons.settings),
          label: 'Settings')
    ];

    return Consumer<AppProvider>(
      builder: (context, model, child) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomNavbarItems,
        onTap: (int index) {
          model.navbarIndex = index;
          Navigator.of(context).pushReplacementNamed(routes[index]);
        },
        currentIndex: model.navbarIndex,
        selectedLabelStyle: _bottomNavBarStyle,
        unselectedLabelStyle: _bottomNavBarStyle,
      ),
    );
  }
}
