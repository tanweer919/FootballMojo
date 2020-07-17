import 'package:sportsmojo/models/Score.dart';
import 'NewsService.dart';
import 'TeamService.dart';
import 'ScoreService.dart';
import 'StatService.dart';
import 'MatchEventService.dart';
import 'package:get_it/get_it.dart';
import '../Provider/HomeViewModel.dart';
import '../Provider/AppProvider.dart';
import '../Provider/AllScoresViewModel.dart';
import '../Provider/FavouriteScoresViewModel.dart';
import '../Provider/MatchStatViewModel.dart';
import '../Provider/MatchEventViewModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  locator.registerLazySingleton<NewsService>(() => NewsService());
  locator.registerLazySingleton<TeamService>(() => TeamService());
  locator.registerLazySingleton<ScoreService>(() => ScoreService());
  locator.registerLazySingleton<StatService>(() => StatService());
  locator.registerLazySingleton<MatchEventService>(() => MatchEventService());
  locator.registerFactory<HomeViewModel>(() => HomeViewModel(0));
  locator.registerFactory<MatchStatViewModel>(() => MatchStatViewModel(null));
  locator.registerFactory<MatchEventViewModel>(() => MatchEventViewModel(null));
  locator.registerFactoryParam<FavouriteScoresViewModel, List<Score>, int>((scores, index) => FavouriteScoresViewModel(scores, index));
  locator.registerFactoryParam<AppProvider, String, void>((leagueName, _) => AppProvider(0, leagueName, now.subtract(Duration(days: 30)), now.add(Duration(days: 7))));
}