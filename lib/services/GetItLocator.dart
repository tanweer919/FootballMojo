import 'NewsService.dart';
import 'TeamService.dart';
import 'ScoreService.dart';
import 'package:get_it/get_it.dart';
import '../Provider/HomeViewModel.dart';
import '../Provider/AppProvider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<NewsService>(() => NewsService());
  locator.registerLazySingleton<TeamService>(() => TeamService());
  locator.registerLazySingleton<ScoreService>(() => ScoreService());
  locator.registerFactory<HomeViewModel>(() => HomeViewModel(0));
  locator.registerFactory<AppProvider>(() => AppProvider(0));
}