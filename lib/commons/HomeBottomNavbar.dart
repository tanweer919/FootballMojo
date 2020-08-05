import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_icons.dart';
import '../Provider/AppProvider.dart';
import '../Provider/ThemeProvider.dart';
import 'GlobalKeys.dart';
class HomeBottomNavbar extends StatelessWidget {
  final List<String> routes = ['/home', '/score', '/league', '/news', '/dashboard'];
  Widget build(BuildContext context){
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final _bottomNavBarStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: _themeProvider.appTheme == AppTheme.Light ? Colors.black : Colors.white,
    );
    final List<BottomNavigationBarItem> bottomNavbarItems = [
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.home__1_, key: GlobalKeys.homeScreenKey, color: Theme.of(context).primaryColor,),
          icon: Icon(MyFlutterApp.home__1_,),
          title: Text('Home', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.score, color: Theme.of(context).primaryColor,),
          icon: Icon(MyFlutterApp.score, key: GlobalKeys.scoreScreenKey,),
          title: Text('Matches', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(Icons.table_chart, color: Theme.of(context).primaryColor,),
          icon: Icon(Icons.table_chart, key: GlobalKeys.leagueScreenKey,),
          title: Text('League', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(MyFlutterApp.news, color: Theme.of(context).primaryColor,),
          icon: Icon(MyFlutterApp.news, key: GlobalKeys.newsScreenKey,),
          title: Text('News', style: _bottomNavBarStyle,)
      ),
      new BottomNavigationBarItem(
          activeIcon: Icon(Icons.settings, color: Theme.of(context).primaryColor,),
          icon: Icon(Icons.settings, key: GlobalKeys.dashboardScreenKey,),
          title: Text('Settings', style: _bottomNavBarStyle,)
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