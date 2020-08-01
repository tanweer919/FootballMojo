import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_icons.dart';
import '../Provider/AppProvider.dart';
import '../Provider/ThemeProvider.dart';
class BottomNavbar extends StatelessWidget {
  final List<String> routes = ['/home', '/score', '/league', '/news', '/dashboard'];
  Widget build(BuildContext context){
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final _bottomNavBarStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: _themeProvider.appTheme == AppTheme.Light ? Colors.black : Colors.white,
    );
    final List<BottomNavigationBarItem> bottomNavbarItems = [
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.home__1_, color: Theme.of(context).primaryColor,),
          icon: Icon(MyFlutterApp.home__1_),
          title: Text('Home', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.score, color: Theme.of(context).primaryColor,),
          icon: Icon(MyFlutterApp.score),
          title: Text('Matches', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(Icons.table_chart, color: Theme.of(context).primaryColor,),
          icon: Icon(Icons.table_chart),
          title: Text('League', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.news, color: Theme.of(context).primaryColor,),
          icon: Icon(MyFlutterApp.news),
          title: Text('News', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(Icons.dashboard, color: Theme.of(context).primaryColor,),
          icon: Icon(Icons.dashboard),
          title: Text('Dasboard', style: _bottomNavBarStyle,)
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