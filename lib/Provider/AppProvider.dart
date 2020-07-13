import 'package:flutter/material.dart';
import 'package:sportsmojo/models/Score.dart';
import 'package:sportsmojo/services/ScoreService.dart';
import '../services/NewsService.dart';
import '../services/LocalStorage.dart';
import '../services/GetItLocator.dart';
import '../models/News.dart';
class AppProvider extends ChangeNotifier {
  int _navbarIndex;
  List<News> _newsList;
  List<News> _favouriteNewsList;
  List<Score> _leagueWiseScores;

  List<Score> _favouriteTeamScores;
  AppProvider(this._navbarIndex);
  int get navbarIndex => _navbarIndex;

  void set navbarIndex(int index) {
    _navbarIndex = index;
    notifyListeners();
  }
  NewsService _newsService = locator<NewsService>();
  ScoreService _scoreService = locator<ScoreService>();
  
  Future<void> loadAllNews() async{
    _newsList = await _newsService.fetchNews('football');
    notifyListeners();
  }

  Future<void> loadFavouriteNews() async {
    String teamName = await LocalStorage.getString('teamName');
    _favouriteNewsList = await  _newsService.fetchNews(teamName);
    notifyListeners();
  }

  Future<void> loadLeagueWiseScores() async {
    String leagueId = await LocalStorage.getString('leagueId');
    _leagueWiseScores = await _scoreService.fetchScoresByLeague(id: leagueId);
    notifyListeners();
  }

  Future<void> loadFavouriteScores() async {
    String teamId = await LocalStorage.getString('teamId');
    _favouriteTeamScores = await _scoreService.fetchScoresByTeam(id: teamId);
    notifyListeners();
  }

  List<News> get newsList => _newsList;
  List<News> get favouriteNewsList => _favouriteNewsList;
  List<Score> get favouriteTeamScores => _favouriteTeamScores;
  List<Score> get leagueWiseScores => _leagueWiseScores;

  void set newsList(List<News> news) {
    _newsList = news;
    notifyListeners();
  }

  void set favouriteNewsList(List<News> news) {
    _favouriteNewsList = news.sublist(0, 4);
    notifyListeners();
  }

  void set favouriteTeamScores(List<Score> scores) {
    _favouriteTeamScores = scores;
    notifyListeners();
  }

  void set leagueWiseScores(List<Score> scores) {
    _leagueWiseScores = scores;
    notifyListeners();
  }
}