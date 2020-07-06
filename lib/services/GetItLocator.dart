import 'package:sportsmojo/models/Score.dart';
import 'NewsService.dart';
import 'TeamService.dart';
import 'ScoreService.dart';
import 'package:get_it/get_it.dart';
import '../Provider/HomeViewModel.dart';
import '../Provider/AppProvider.dart';
import '../Provider/AllScoresViewModel.dart';
import '../Provider/FavouriteScoresViewModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<NewsService>(() => NewsService());
  locator.registerLazySingleton<TeamService>(() => TeamService());
  locator.registerLazySingleton<ScoreService>(() => ScoreService());
  locator.registerFactory<HomeViewModel>(() => HomeViewModel(0));
  locator.registerFactoryParam<AllScoresViewModel, List<Score>, int>((scores, index) => AllScoresViewModel(scores, index));
  locator.registerFactoryParam<FavouriteScoresViewModel, List<Score>, int>((scores, index) => FavouriteScoresViewModel(scores, index));
  locator.registerFactory<AppProvider>(() => AppProvider(0));
}