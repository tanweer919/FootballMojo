import 'package:flutter/material.dart';
import '../services/NewsService.dart';
import '../services/LocalStorage.dart';
import '../services/GetItLocator.dart';
import '../models/News.dart';
class AppProvider extends ChangeNotifier {
  int _navbarIndex;
  List<News> _newsList;
  List<News> _favouriteNewsList;
  AppProvider(this._navbarIndex);
  int get navbarIndex => _navbarIndex;

  void set navbarIndex(int index) {
    _navbarIndex = index;
    notifyListeners();
  }
  NewsService _newsService = locator<NewsService>();
  Future<void> loadAllNews() async{
    _newsList = await _newsService.fetchNews('football');
    notifyListeners();
  }

  Future<void> loadFavouriteNews() async {
    String teamName = await LocalStorage.getString('teamName');
    _favouriteNewsList = await  _newsService.fetchNews(teamName);
    notifyListeners();
  }

  List<News> get newsList => _newsList;
  List<News> get favouriteNewsList => _favouriteNewsList;

}