import 'package:flutter/material.dart';
import 'package:sportsmojo/models/Score.dart';
import 'package:sportsmojo/services/ScoreService.dart';
import '../services/NewsService.dart';
import '../services/LocalStorage.dart';
import '../services/GetItLocator.dart';
import '../models/News.dart';
import '../constants.dart';
import '../models/LeagueTable.dart';
import '../services/LeagueTableService.dart';
import '../services/TopScorerService.dart';
import '../models/Player.dart';
import '../models/User.dart';

class AppProvider extends ChangeNotifier {
  AppProvider({
    required String? selectedLeague,
    required bool notificationEnabled,
    User? currentUser,
    int navbarIndex = 0,
    DateTime? startDate,
    DateTime? endDate,
  })  : _selectedLeague = selectedLeague,
        _notificationEnabled = notificationEnabled,
        _currentUser = currentUser,
        _navbarIndex = navbarIndex,
        _startDate = startDate,
        _endDate = endDate;

  int _navbarIndex;
  List<News>? _newsList;
  List<News>? _favouriteNewsList;
  List<Score>? _leagueWiseScores;
  List<LeagueTableEntry>? _leagueTableEntries;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Score>? _favouriteTeamScores;
  String? _selectedLeague;
  List<Player>? _topScorers;
  User? _currentUser;
  bool _notificationEnabled;

  final NewsService _newsService = locator<NewsService>();
  final ScoreService _scoreService = locator<ScoreService>();
  final LeagueTableService _leagueTableService = locator<LeagueTableService>();
  final TopScorerService _topScorerService = locator<TopScorerService>();

  int get navbarIndex => _navbarIndex;

  String? get selectedLeague => _selectedLeague;

  List<News>? get newsList => _newsList;
  List<News>? get favouriteNewsList => _favouriteNewsList;
  List<Score>? get favouriteTeamScores => _favouriteTeamScores;
  List<Score>? get leagueWiseScores => _leagueWiseScores;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  List<LeagueTableEntry>? get leagueTableEntries => _leagueTableEntries;
  List<Player>? get topScorers => _topScorers;
  User? get currentUser => _currentUser;

  bool get notificationEnabled => _notificationEnabled;

  void set selectedLeague(String? league) {
    _selectedLeague = league;
    notifyListeners();
  }

  void set navbarIndex(int index) {
    _navbarIndex = index;
    notifyListeners();
  }

  void set newsList(List<News>? news) {
    _newsList = news;
    notifyListeners();
  }

  void set favouriteNewsList(List<News>? news) {
    if (news != null && news.length >= 4) {
      _favouriteNewsList = news.sublist(0, 4);
    } else {
      _favouriteNewsList = news;
    }
    notifyListeners();
  }

  void set favouriteTeamScores(List<Score>? scores) {
    _favouriteTeamScores = scores;
    notifyListeners();
  }

  void set leagueWiseScores(List<Score>? scores) {
    _leagueWiseScores = scores;
    notifyListeners();
  }

  void set startDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  void set endDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  void set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void set leagueTableEntries(List<LeagueTableEntry>? newLeagueTable) {
    _leagueTableEntries = newLeagueTable;
    notifyListeners();
  }

  void set topScorers(List<Player>? scorers) {
    _topScorers = scorers;
    notifyListeners();
  }

  void set notificationEnabled(bool value) {
    _notificationEnabled = value;
    notifyListeners();
  }

  Future<void> loadAllNews() async {
    // Assuming fetchNews can handle a non-nullable String and returns List<News> (not null)
    // If fetchNews can return null, then List<News>? allNews = ...
    String placeholderUrl = 'https://res.cloudinary.com/doy9hqxr1/image/upload/q_70/v1596572656/Football-Class-Cover-Page_sjrsaq.jpg';
    List<News> allNews = await _newsService.fetchNews('european football');
    // The where clauses and toList() will produce non-null lists, possibly empty.
    List<News> allNewsFirst = allNews.where((news) => news.imageUrl != placeholderUrl).toList();
    List<News> allNewsSecond = allNews.where((news) => news.imageUrl == placeholderUrl).toList();
    _newsList = allNewsFirst + allNewsSecond;
    notifyListeners();
  }

  Future<void> loadFavouriteNews() async {
    String placeholderUrl = 'https://res.cloudinary.com/doy9hqxr1/image/upload/q_70/v1596572656/Football-Class-Cover-Page_sjrsaq.jpg';
    String? teamName = await LocalStorage.getString('teamName');
    if (teamName == null) {
      // Handle null teamName, e.g., load default news or do nothing
      _favouriteNewsList = []; // Example: set to empty list
      notifyListeners();
      return;
    }
    // Assuming fetchNews can handle a non-nullable String and returns List<News>
    List<News> favouriteNews = await _newsService.fetchNews(teamName);
    List<News> favouriteNewsFirst = favouriteNews.where((news) => news.imageUrl != placeholderUrl).toList();
    List<News> favouriteNewsSecond = favouriteNews.where((news) => news.imageUrl == placeholderUrl).toList();
    _favouriteNewsList = favouriteNewsFirst + favouriteNewsSecond;
    notifyListeners();
  }

  Future<void> loadLeagueWiseScores({String? leagueName}) async {
    final currentLeagueName = leagueName ?? _selectedLeague;
    if (currentLeagueName == null) {
      // Handle case where no league is selected or provided
      _leagueWiseScores = []; // Example: set to empty list
      notifyListeners();
      return;
    }
    // Ensure leagues[currentLeagueName] and leagues[currentLeagueName]['id'] are safe
    final leagueData = leagues[currentLeagueName];
    if (leagueData == null || leagueData['id'] == null) {
      _leagueWiseScores = [];
      notifyListeners();
      return;
    }
    String leagueId = '${leagueData['id']}';
    // Assuming fetchScoresByLeague returns List<Score> (not null)
    _leagueWiseScores = await _scoreService.fetchScoresByLeague(id: leagueId);
    notifyListeners();
  }

  Future<void> loadFavouriteScores() async {
    String? teamId = await LocalStorage.getString('teamId');
    if (teamId == null) {
      // Handle null teamId
      _favouriteTeamScores = []; // Example: set to empty list
      notifyListeners();
      return;
    }
    // Assuming fetchScoresByTeam returns List<Score> (not null)
    _favouriteTeamScores = await _scoreService.fetchScoresByTeam(id: teamId);
    notifyListeners();
  }

  Future<void> loadLeagueTable({String? leagueName}) async {
    final currentLeagueName = leagueName ?? _selectedLeague;
    if (currentLeagueName == null) {
      _leagueTableEntries = [];
      notifyListeners();
      return;
    }
    final leagueData = leagues[currentLeagueName];
    if (leagueData == null || leagueData['id'] == null) {
      _leagueTableEntries = [];
      notifyListeners();
      return;
    }
    String leagueId = '${leagueData['id']}';
    // Assuming fetchLeagueTable returns List<LeagueTableEntry> (not null)
    _leagueTableEntries = await _leagueTableService.fetchLeagueTable(id: leagueId);
    notifyListeners();
  }

  Future<void> loadTopScorers({String? leagueName}) async {
    final currentLeagueName = leagueName ?? _selectedLeague;
    if (currentLeagueName == null) {
      _topScorers = [];
      notifyListeners();
      return;
    }
    final leagueData = leagues[currentLeagueName];
    if (leagueData == null || leagueData['id'] == null) {
      _topScorers = [];
      notifyListeners();
      return;
    }
    String leagueId = '${leagueData['id']}';
    // Assuming fetchTopScorer returns List<Player> (not null)
    _topScorers = await _topScorerService.fetchTopScorer(leagueId: leagueId);
    notifyListeners();
  }
}