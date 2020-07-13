import 'package:flutter/foundation.dart';
import 'package:sportsmojo/models/News.dart';
import 'package:sportsmojo/services/GetItLocator.dart';
import 'package:sportsmojo/services/NewsService.dart';
import '../services/LocalStorage.dart';

class HomeViewModel extends ChangeNotifier {
  int _carouselIndex;
  HomeViewModel(this._carouselIndex);

  int get carouselIndex => _carouselIndex;
  void set carouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }
}