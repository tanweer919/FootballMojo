import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  int _carouselIndex;
  HomeViewModel({required int carouselIndex}) : _carouselIndex = carouselIndex;

  int get carouselIndex => _carouselIndex;
  void set carouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }
}