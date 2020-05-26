import 'package:flutter/cupertino.dart';
import '../screens/HomeScreen.dart';
import '../screens/Score.dart';
import '../screens/News.dart';
import '../screens/Login.dart';
import '../screens/NewsArticle.dart';
import '../models/News.dart';
import '../screens/FavouriteScreen2.dart';

class Router {
  Route<dynamic> generateRoutes(RouteSettings settings) {
    final List<String> validRoutes = [
      '/home',
      '/score',
      '/news',
      '/login',
      '/newsarticle',
      '/selectteam'
    ];
    if (validRoutes.contains(settings.name)) {
      return customRoutes(settings.name, settings.arguments);
    }
  }

  PageRouteBuilder<dynamic> customRoutes(String route, Map args) {
    News news = null;
    int index = null;
    int leagueId = null;
    Map<String, dynamic> favouriteTeamMessage = null;
    if (args != null) {
      if (args.containsKey('index')) {
        index = args['index'];
      }
      if (args.containsKey('news')) {
        news = args['news'];
      }
      if (args.containsKey('leagueId')) {
        leagueId = args['leagueId'];
      }
      if (args.containsKey('favouriteTeamMessage')) {
        favouriteTeamMessage = args['favouriteTeamMessage'];
      }
    }
    Map<String, Widget> screens = {
      '/home': HomeScreen(
        message: favouriteTeamMessage,
      ),
      '/score': ScoreScreen(),
      '/news': NewsScreen(),
      '/login': LoginScreen(),
      '/newsarticle': NewsArticleScreen(
        index: index,
        news: news,
      ),
      '/selectteam': FavouriteTeam(
        leagueId: leagueId,
      )
    };

    return PageRouteBuilder(
        pageBuilder: (_, __, ___) => screens[route],
        transitionsBuilder: (_, anim, __, child) {
          return route == '/selectteam'
              ? SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(-1.0, 0.0), end: Offset.zero)
                      .animate(anim),
                  child: child,
                )
              : FadeTransition(opacity: anim, child: child);
        },
        transitionDuration:
            Duration(milliseconds: route == '/newsarticle' ? 500 : 300));
  }
}
