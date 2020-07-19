import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_icons.dart';
import '../Provider/AppProvider.dart';
class BottomNavbar extends StatelessWidget {
  static final _bottomNavBarStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  final List<String> routes = ['/home', '/score', '/league', '/news', '/login'];
  Widget build(BuildContext context){
    final List<BottomNavigationBarItem> bottomNavbarItems = [
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.home__1_, color: Colors.orange,),
          icon: Icon(MyFlutterApp.home__1_),
          title: Text('Home', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.score, color: Colors.orange,),
          icon: Icon(MyFlutterApp.score),
          title: Text('Matches', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(Icons.table_chart, color: Colors.orange,),
          icon: Icon(Icons.table_chart),
          title: Text('League', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.news, color: Colors.orange,),
          icon: Icon(MyFlutterApp.news),
          title: Text('News', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(Icons.account_circle, color: Colors.orange,),
          icon: Icon(Icons.account_circle),
          title: Text('Login', style: _bottomNavBarStyle,)
      )
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
      ),
    );
  }
}