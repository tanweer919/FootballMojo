import 'package:flutter/material.dart';
import 'package:sportsmojo/models/Score.dart';
import 'package:sportsmojo/screens/MatchStatScreen.dart';
import '../screens/HomeScreen.dart';
import '../screens/ScoreScreen.dart';
import '../screens/NewsScreen.dart';
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
import '../screens/NotFound.dart';

class RouterService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  Route<dynamic> generateRoutes(RouteSettings settings) {
    final String? routeName = settings.name;
    final Object? routeArgs = settings.arguments;

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

    if (routeName != null && validRoutes.contains(routeName)) {
      return customRoutes(routeName, routeArgs);
    } else {
      // Fallback for invalid or null route names
      return MaterialPageRoute(builder: (_) => NotFound());
    }
  }

  PageRouteBuilder<dynamic> customRoutes(String routeName, Object? routeArgs) {
    final Map<dynamic, dynamic>? args = routeArgs as Map<dynamic, dynamic>?;

    News? news;
    int? index;
    int? leagueId;
    String? leagueName;
    String? from;
    Map<String, dynamic>? favouriteTeamMessage;
    Score? score;
    bool showTutorial = false; // Default value

    if (args != null) {
      if (args.containsKey('index')) {
        index = args['index'] as int?;
      }
      if (args.containsKey('news')) {
        news = args['news'] as News?;
      }
      if (args.containsKey('leagueId')) {
        leagueId = args['leagueId'] as int?;
      }
      if (args.containsKey('leagueName')) {
        leagueName = args['leagueName'] as String?;
      }
      if (args.containsKey('favouriteTeamMessage')) {
        favouriteTeamMessage = args['favouriteTeamMessage'] as Map<String, dynamic>?;
      }
      if (args.containsKey('score')) {
        score = args['score'] as Score?;
      }
      if (args.containsKey('from')) {
        from = args['from'] as String?;
      }
      if (args.containsKey('showTutorial')) {
        // Ensure showTutorial is bool, provide default if not or if key missing
        final dynamic tutorialArg = args['showTutorial'];
        if (tutorialArg is bool) {
          showTutorial = tutorialArg;
        }
      }
    }

    // Assuming Screen constructors are updated to handle nullable types or defaults.
    // For example, HomeScreen might need: HomeScreen({this.message, this.showTutorial = false})
    // NewsArticleScreen might need: NewsArticleScreen({this.index, this.news})
    // FavouriteTeam might need: FavouriteTeam({this.leagueId, this.leagueName})
    // MatchStatScreen might need: MatchStatScreen({this.score})
    // NoInternetScreen might need: NoInternetScreen({this.from})

    Map<String, Widget> screens = {
      '/start': Start(),
      '/home': HomeScreen(
          message: favouriteTeamMessage, showTutorial: showTutorial),
      '/score': ScoreScreen(),
      '/league': LeagueTableScreen(),
      '/news': NewsScreen(),
      '/dashboard': DashboardScreen(),
      '/newsarticle': NewsArticleScreen(index: index, news: news),
      '/selectteam':
          FavouriteTeam(leagueId: leagueId, leagueName: leagueName),
      '/matchstat': MatchStatScreen(score: score),
      '/selectleague': FavouriteLeague(),
      '/introduction': IntroductionScreen(),
      '/nointernet': NoInternetScreen(from: from)
    };

    final Widget screenWidget = screens[routeName] ?? NotFound(); // Fallback if routeName somehow not in map

    return PageRouteBuilder(
        pageBuilder: (_, __, ___) => screenWidget,
        transitionsBuilder: (_, anim, __, child) {
          return routeName == '/selectteam'
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
        transitionDuration: Duration(
            milliseconds: routeName == '/newsarticle' ? 500 : 250));
  }
}
