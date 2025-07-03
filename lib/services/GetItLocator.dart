import 'package:get_it/get_it.dart';
import '../models/Score.dart';
import 'NewsService.dart';
import 'TeamService.dart';
import 'ScoreService.dart';
import 'StatService.dart';
import 'MatchEventService.dart';
import 'LeagueTableService.dart';
import 'TopScorerService.dart';
import '../Provider/HomeViewModel.dart';
import '../Provider/AppProvider.dart';
import '../Provider/FavouriteScoresViewModel.dart';
import '../Provider/MatchStatViewModel.dart';
import '../Provider/MatchEventViewModel.dart';
import '../models/User.dart';
import 'FirebaseService.dart';
import 'FirestoreService.dart';
import 'RemoteConfigService.dart';
import 'NetworkStatusService.dart';
import 'FirebaseMessagingService.dart';
import 'CustomRouter.dart';
import '../Provider/ThemeProvider.dart';
import 'AnalyticsService.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HttpService.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize RemoteConfigService
  RemoteConfigService remoteConfigService =
      await RemoteConfigService.getInstance();

  // Initialize Dio client
  final dio = await HttpService.getApiClient();

  // Register services
  locator.registerLazySingleton<NewsService>(
      () => NewsService(remoteConfigService));
  locator.registerLazySingleton<TeamService>(() => TeamService());
  locator.registerLazySingleton<ScoreService>(
      () => ScoreService(dio, remoteConfigService));
  locator.registerLazySingleton<StatService>(() => StatService());
  locator.registerLazySingleton<MatchEventService>(() => MatchEventService());
  locator.registerLazySingleton<LeagueTableService>(
      () => LeagueTableService(dio, remoteConfigService));
  locator.registerLazySingleton<TopScorerService>(
      () => TopScorerService(dio, remoteConfigService));
  locator.registerLazySingleton<FirebaseService>(
      () => FirebaseService(prefs: prefs));
  locator.registerLazySingleton<FirestoreService>(() => FirestoreService());
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  locator.registerLazySingleton<NetworkStatusService>(
      () => NetworkStatusService());
  locator.registerSingleton<RemoteConfigService>(remoteConfigService);
  locator.registerLazySingleton<FirebaseMessagingService>(
      () => FirebaseMessagingService());
  locator.registerLazySingleton<RouterService>(() => RouterService());

  // Register ViewModels
  locator.registerFactory<HomeViewModel>(
      () => HomeViewModel(carouselIndex: 0, prefs: prefs));
  locator
      .registerFactory<MatchStatViewModel>(() => MatchStatViewModel(stats: {}));
  locator.registerFactory<MatchEventViewModel>(() => MatchEventViewModel(
      events: [], eventService: locator<MatchEventService>(), prefs: prefs));

  // Register AppProvider with all required dependencies
  locator.registerFactoryParam<AppProvider, Map<String, dynamic>, User?>(
      (map, currentUser) => AppProvider(
            prefs: prefs,
            newsService: locator<NewsService>(),
            scoreService: locator<ScoreService>(),
            leagueTableService: locator<LeagueTableService>(),
            topScorerService: locator<TopScorerService>(),
            selectedLeague: map['leagueName'] as String?,
            notificationEnabled: map['notificationEnabled'] as bool,
            currentUser: currentUser,
            navbarIndex: 0,
            startDate: now.subtract(Duration(days: 90)),
            endDate: now.add(Duration(days: 7)),
          ));

  // Register ThemeProvider
  locator.registerFactoryParam<ThemeProvider, AppTheme, void>(
      (theme, _) => ThemeProvider(appTheme: theme, prefs: prefs));
}
