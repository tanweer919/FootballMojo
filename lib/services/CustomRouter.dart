import 'package:flutter/cupertino.dart';
import 'package:sportsmojo/models/Score.dart';
import 'package:sportsmojo/screens/MatchStatScreen.dart';
import '../screens/HomeScreen.dart';
import '../screens/ScoreScreen.dart';
import '../screens/News.dart';
import '../screens/NewsArticle.dart';
import '../models/News.dart';
import '../screens/FavouriteScreen2.dart';
import '../screens/LeagueTableScreen.dart';
import '../screens/DashboardScreen.dart';
import '../screens/FavouriteScreen1.dart';
import '../screens/IntroductionScreen.dart';
import '../start.dart';
import '../screens/NoInternetScreen.dart';
import '../commons/NetworkAwareWidget.dart';

class Router {
  Route<dynamic> generateRoutes(RouteSettings settings) {
    final List<String> validRoutes = [
      '/start',
      '/home',
      '/score',
      '/league',
      '/news',
      '/dashboard',
      '/newsarticle',
      '/selectteam',
      '/matchstat',
      '/selectleague',
      '/introduction',
      '/nointernet'
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
    String from;
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
      if (args.containsKey('from')) {
        from = args['from'];
      }
    }
    Map<String, Widget> screens = {
      '/start': Start(),
      '/home': HomeScreen(
        message: favouriteTeamMessage,
      ),
      '/score': ScoreScreen(),
      '/league': LeagueTableScreen(),
      '/news': NewsScreen(),
      '/dashboard': DashboardScreen(),
      '/newsarticle': NewsArticleScreen(
        index: index,
        news: news,
      ),
      '/selectteam': FavouriteTeam(leagueId: leagueId, leagueName: leagueName),
      '/matchstat': MatchStatScreen(
        score: score,
      ),
      '/selectleague': FavouriteLeague(),
      '/introduction': IntroductionScreen(),
      '/nointernet': NoInternetScreen(
        from: from,
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
                  child: NetworkAwareWidget(
                    child: child,
                  ),
                )
              : FadeTransition(
                  opacity: anim, child: NetworkAwareWidget(child: child));
        },
        transitionDuration:
            Duration(milliseconds: route == '/newsarticle' ? 500 : 300));
  }
}
