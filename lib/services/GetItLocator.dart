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
  locator.registerLazySingleton<NewsService>(() => NewsService());
  locator.registerLazySingleton<TeamService>(() => TeamService());
  locator.registerLazySingleton<ScoreService>(() => ScoreService());
  locator.registerLazySingleton<StatService>(() => StatService());
  locator.registerLazySingleton<MatchEventService>(() => MatchEventService());
  locator.registerFactory<HomeViewModel>(() => HomeViewModel(0));
  locator.registerFactory<MatchStatViewModel>(() => MatchStatViewModel(null));
  locator.registerFactory<MatchEventViewModel>(() => MatchEventViewModel(null));
  locator.registerFactoryParam<AllScoresViewModel, String, void>((league, _) => AllScoresViewModel(league));
  locator.registerFactoryParam<FavouriteScoresViewModel, List<Score>, int>((scores, index) => FavouriteScoresViewModel(scores, index));
  locator.registerFactory<AppProvider>(() => AppProvider(0));
}