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
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class that manages the app's global state.
///
/// This class handles:
/// - User state
/// - News state
/// - Scores state
/// - League table state
/// - Top scorers state
/// - Navigation state
class AppProvider extends ChangeNotifier {
  static const String _selectedLeagueKey = 'selected_league';
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _navbarIndexKey = 'navbar_index';
  static const String _startDateKey = 'start_date';
  static const String _endDateKey = 'end_date';
  static const String _currentUserKey = 'current_user';

  final SharedPreferences _prefs;
  final NewsService _newsService;
  final ScoreService _scoreService;
  final LeagueTableService _leagueTableService;
  final TopScorerService _topScorerService;
  bool _isInitialized = false;

  AppProvider({
    required SharedPreferences prefs,
    required NewsService newsService,
    required ScoreService scoreService,
    required LeagueTableService leagueTableService,
    required TopScorerService topScorerService,
    String? selectedLeague,
    bool notificationEnabled = false,
    User? currentUser,
    int navbarIndex = 0,
    DateTime? startDate,
    DateTime? endDate,
  })  : _prefs = prefs,
        _newsService = newsService,
        _scoreService = scoreService,
        _leagueTableService = leagueTableService,
        _topScorerService = topScorerService,
        _selectedLeague = selectedLeague,
        _notificationEnabled = notificationEnabled,
        _currentUser = currentUser,
        _navbarIndex = navbarIndex,
        _startDate = startDate,
        _endDate = endDate,
        _newsList = [],
        _favouriteNewsList = [],
        _leagueWiseScores = [],
        _leagueTableEntries = [],
        _favouriteTeamScores = [],
        _topScorers = [] {
    _initialize();
  }

  final List<News> _newsList;
  final List<News> _favouriteNewsList;
  final List<Score> _leagueWiseScores;
  final List<LeagueTableEntry> _leagueTableEntries;
  final List<Score> _favouriteTeamScores;
  final List<Player> _topScorers;

  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedLeague;
  User? _currentUser;
  bool _notificationEnabled;
  int _navbarIndex;

  int get navbarIndex => _navbarIndex;
  String? get selectedLeague => _selectedLeague;
  List<News> get newsList => List.unmodifiable(_newsList);
  List<News> get favouriteNewsList => List.unmodifiable(_favouriteNewsList);
  List<Score> get favouriteTeamScores =>
      List.unmodifiable(_favouriteTeamScores);
  List<Score> get leagueWiseScores => List.unmodifiable(_leagueWiseScores);
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<LeagueTableEntry> get leagueTableEntries =>
      List.unmodifiable(_leagueTableEntries);
  List<Player> get topScorers => List.unmodifiable(_topScorers);
  User? get currentUser => _currentUser;
  bool get notificationEnabled => _notificationEnabled;

  /// Initializes the provider by loading saved state.
  Future<void> _initialize() async {
    if (_isInitialized) {
      developer.log('AppProvider already initialized');
      return;
    }

    try {
      developer.log('Initializing AppProvider');
      await _loadState();
      _isInitialized = true;
      developer.log('AppProvider initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing AppProvider',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Loads the saved state from persistent storage.
  Future<void> _loadState() async {
    try {
      _selectedLeague = _prefs.getString(_selectedLeagueKey);
      _notificationEnabled = _prefs.getBool(_notificationEnabledKey) ?? false;
      _navbarIndex = _prefs.getInt(_navbarIndexKey) ?? 0;

      final startDateStr = _prefs.getString(_startDateKey);
      if (startDateStr != null) {
        _startDate = DateTime.parse(startDateStr);
      }

      final endDateStr = _prefs.getString(_endDateKey);
      if (endDateStr != null) {
        _endDate = DateTime.parse(endDateStr);
      }

      final userStr = _prefs.getString(_currentUserKey);
      if (userStr != null) {
        _currentUser = User.fromJsonString(userStr);
      }

      developer.log('Loaded state: selectedLeague=$_selectedLeague, '
          'notificationEnabled=$_notificationEnabled, '
          'navbarIndex=$_navbarIndex');
    } catch (e, stackTrace) {
      developer.log(
        'Error loading state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Saves the current state to persistent storage.
  Future<void> _saveState() async {
    try {
      if (_selectedLeague != null) {
        await _prefs.setString(_selectedLeagueKey, _selectedLeague!);
      }
      await _prefs.setBool(_notificationEnabledKey, _notificationEnabled);
      await _prefs.setInt(_navbarIndexKey, _navbarIndex);

      if (_startDate != null) {
        await _prefs.setString(_startDateKey, _startDate!.toIso8601String());
      }

      if (_endDate != null) {
        await _prefs.setString(_endDateKey, _endDate!.toIso8601String());
      }

      if (_currentUser != null) {
        await _prefs.setString(_currentUserKey, _currentUser!.toJsonString());
      }

      developer.log('Saved state: selectedLeague=$_selectedLeague, '
          'notificationEnabled=$_notificationEnabled, '
          'navbarIndex=$_navbarIndex');
    } catch (e, stackTrace) {
      developer.log(
        'Error saving state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void set selectedLeague(String? league) {
    if (_selectedLeague != league) {
      _selectedLeague = league;
      _saveState();
      notifyListeners();
    }
  }

  void set navbarIndex(int index) {
    if (_navbarIndex != index) {
      _navbarIndex = index;
      _saveState();
      notifyListeners();
    }
  }

  void set newsList(List<News> news) {
    _newsList.clear();
    _newsList.addAll(news);
    notifyListeners();
  }

  void set favouriteNewsList(List<News> news) {
    _favouriteNewsList.clear();
    if (news.length >= 4) {
      _favouriteNewsList.addAll(news.sublist(0, 4));
    } else {
      _favouriteNewsList.addAll(news);
    }
    notifyListeners();
  }

  void set favouriteTeamScores(List<Score> scores) {
    _favouriteTeamScores.clear();
    _favouriteTeamScores.addAll(scores);
    notifyListeners();
  }

  void set leagueWiseScores(List<Score> scores) {
    _leagueWiseScores.clear();
    _leagueWiseScores.addAll(scores);
    notifyListeners();
  }

  void set startDate(DateTime? date) {
    if (_startDate != date) {
      _startDate = date;
      _saveState();
      notifyListeners();
    }
  }

  void set endDate(DateTime? date) {
    if (_endDate != date) {
      _endDate = date;
      _saveState();
      notifyListeners();
    }
  }

  void set currentUser(User? user) {
    if (_currentUser != user) {
      _currentUser = user;
      _saveState();
      notifyListeners();
    }
  }

  void set leagueTableEntries(List<LeagueTableEntry> newLeagueTable) {
    _leagueTableEntries.clear();
    _leagueTableEntries.addAll(newLeagueTable);
    notifyListeners();
  }

  void set topScorers(List<Player> scorers) {
    _topScorers.clear();
    _topScorers.addAll(scorers);
    notifyListeners();
  }

  void set notificationEnabled(bool value) {
    if (_notificationEnabled != value) {
      _notificationEnabled = value;
      _saveState();
      notifyListeners();
    }
  }

  Future<void> loadAllNews() async {
    const String placeholderUrl =
        'https://res.cloudinary.com/doy9hqxr1/image/upload/q_70/v1596572656/Football-Class-Cover-Page_sjrsaq.jpg';
    try {
      developer.log('Loading all news');
      final List<News> allNews =
          await _newsService.fetchNews('european football');
      final List<News> allNewsFirst =
          allNews.where((news) => news.imageUrl != placeholderUrl).toList();
      final List<News> allNewsSecond =
          allNews.where((news) => news.imageUrl == placeholderUrl).toList();
      _newsList.clear();
      _newsList.addAll([...allNewsFirst, ...allNewsSecond]);
      developer.log('Loaded ${_newsList.length} news items');
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading all news',
        error: e,
        stackTrace: stackTrace,
      );
      _newsList.clear();
      notifyListeners();
    }
  }

  Future<void> loadFavouriteNews() async {
    const String placeholderUrl =
        'https://res.cloudinary.com/doy9hqxr1/image/upload/q_70/v1596572656/Football-Class-Cover-Page_sjrsaq.jpg';
    try {
      developer.log('Loading favourite news');
      final String? teamName = await LocalStorage.getString('teamName');
      if (teamName == null) {
        developer.log('No team name found for favourite news');
        _favouriteNewsList.clear();
        notifyListeners();
        return;
      }
      final List<News> favouriteNews = await _newsService.fetchNews(teamName);
      final List<News> favouriteNewsFirst = favouriteNews
          .where((news) => news.imageUrl != placeholderUrl)
          .toList();
      final List<News> favouriteNewsSecond = favouriteNews
          .where((news) => news.imageUrl == placeholderUrl)
          .toList();
      _favouriteNewsList.clear();
      _favouriteNewsList
          .addAll([...favouriteNewsFirst, ...favouriteNewsSecond]);
      developer.log('Loaded ${_favouriteNewsList.length} favourite news items');
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading favourite news',
        error: e,
        stackTrace: stackTrace,
      );
      _favouriteNewsList.clear();
      notifyListeners();
    }
  }

  Future<void> loadLeagueWiseScores({String? leagueName}) async {
    try {
      developer.log('Loading league wise scores');
      final currentLeagueName = leagueName ?? _selectedLeague;
      if (currentLeagueName == null) {
        developer.log('No league selected for scores');
        _leagueWiseScores.clear();
        notifyListeners();
        return;
      }
      final leagueData = leagues[currentLeagueName];
      if (leagueData == null || leagueData['id'] == null) {
        developer.log('Invalid league data for $currentLeagueName');
        _leagueWiseScores.clear();
        notifyListeners();
        return;
      }
      final String leagueId = '${leagueData['id']}';
      final List<Score> scores =
          await _scoreService.fetchScoresByLeague(id: leagueId);
      _leagueWiseScores.clear();
      _leagueWiseScores.addAll(scores);
      developer.log('Loaded ${_leagueWiseScores.length} league wise scores');
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading league wise scores',
        error: e,
        stackTrace: stackTrace,
      );
      _leagueWiseScores.clear();
      notifyListeners();
    }
  }

  Future<void> loadFavouriteScores() async {
    try {
      developer.log('Loading favourite scores');
      final String? teamId = await LocalStorage.getString('teamId');
      if (teamId == null) {
        developer.log('No team ID found for favourite scores');
        _favouriteTeamScores.clear();
        notifyListeners();
        return;
      }
      final List<Score> scores =
          await _scoreService.fetchScoresByTeam(id: teamId);
      _favouriteTeamScores.clear();
      _favouriteTeamScores.addAll(scores);
      developer.log('Loaded ${_favouriteTeamScores.length} favourite scores');
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading favourite scores',
        error: e,
        stackTrace: stackTrace,
      );
      _favouriteTeamScores.clear();
      notifyListeners();
    }
  }

  Future<void> loadLeagueTable({String? leagueName}) async {
    try {
      developer.log('Loading league table');
      final currentLeagueName = leagueName ?? _selectedLeague;
      if (currentLeagueName == null) {
        developer.log('No league selected for table');
        _leagueTableEntries.clear();
        notifyListeners();
        return;
      }
      final leagueData = leagues[currentLeagueName];
      if (leagueData == null || leagueData['id'] == null) {
        developer.log('Invalid league data for $currentLeagueName');
        _leagueTableEntries.clear();
        notifyListeners();
        return;
      }
      final String leagueId = '${leagueData['id']}';
      final List<LeagueTableEntry> entries =
          await _leagueTableService.fetchLeagueTable(id: leagueId);
      _leagueTableEntries.clear();
      _leagueTableEntries.addAll(entries);
      developer
          .log('Loaded ${_leagueTableEntries.length} league table entries');
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading league table',
        error: e,
        stackTrace: stackTrace,
      );
      _leagueTableEntries.clear();
      notifyListeners();
    }
  }

  Future<void> loadTopScorers({String? leagueName}) async {
    try {
      developer.log('Loading top scorers');
      final currentLeagueName = leagueName ?? _selectedLeague;
      if (currentLeagueName == null) {
        developer.log('No league selected for top scorers');
        _topScorers.clear();
        notifyListeners();
        return;
      }
      final leagueData = leagues[currentLeagueName];
      if (leagueData == null || leagueData['id'] == null) {
        developer.log('Invalid league data for $currentLeagueName');
        _topScorers.clear();
        notifyListeners();
        return;
      }
      final String leagueId = '${leagueData['id']}';
      final List<Player> scorers =
          await _topScorerService.fetchTopScorer(leagueId: leagueId);
      _topScorers.clear();
      _topScorers.addAll(scorers);
      developer.log('Loaded ${_topScorers.length} top scorers');
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading top scorers',
        error: e,
        stackTrace: stackTrace,
      );
      _topScorers.clear();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isInitialized = false;
    _newsList.clear();
    _favouriteNewsList.clear();
    _leagueWiseScores.clear();
    _leagueTableEntries.clear();
    _favouriteTeamScores.clear();
    _topScorers.clear();
    super.dispose();
  }
}
