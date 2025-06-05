import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  int _carouselIndex;
  HomeViewModel(this._carouselIndex);

  int get carouselIndex => _carouselIndex;
  void set carouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }
}