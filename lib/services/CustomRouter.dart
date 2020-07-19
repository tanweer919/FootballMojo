import 'package:flutter/cupertino.dart';
import 'package:sportsmojo/models/Score.dart';
import 'package:sportsmojo/screens/MatchStatScreen.dart';
import '../screens/HomeScreen.dart';
import '../screens/ScoreScreen.dart';
import '../screens/News.dart';
import '../screens/Login.dart';
import '../screens/NewsArticle.dart';
import '../models/News.dart';
import '../screens/FavouriteScreen2.dart';
import '../screens/LeagueTableScreen.dart';

class Router {
  Route<dynamic> generateRoutes(RouteSettings settings) {
    final List<String> validRoutes = [
      '/home',
      '/score',
      '/league',
      '/news',
      '/login',
      '/newsarticle',
      '/selectteam',
      '/matchstat'
    ];
    if (validRoutes.contains(settings.name)) {
      return customRoutes(settings.name, settings.arguments);
    }
  }

  PageRouteBuilder<dynamic> customRoutes(String route, Map args) {
    News news = null;
    int index = null;
    int leagueId = null;
    String leagueName;
    Map<String, dynamic> favouriteTeamMessage = null;
    Score score = null;
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
      if (args.containsKey('leagueName')) {
        leagueName = args['leagueName'];
      }
      if (args.containsKey('favouriteTeamMessage')) {
        favouriteTeamMessage = args['favouriteTeamMessage'];
      }
      if (args.containsKey('score')) {
        score = args['score'];
      }
    }
    Map<String, Widget> screens = {
      '/home': HomeScreen(
        message: favouriteTeamMessage,
      ),
      '/score': ScoreScreen(),
      '/league': LeagueTableScreen(),
      '/news': NewsScreen(),
      '/login': LoginScreen(),
      '/newsarticle': NewsArticleScreen(
        index: index,
        news: news,
      ),
      '/selectteam': FavouriteTeam(
        leagueId: leagueId,
        leagueName: leagueName
      ),
      '/matchstat': MatchStatScreen(
        score: score,
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
