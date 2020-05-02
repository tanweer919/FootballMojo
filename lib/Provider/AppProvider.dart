import 'package:flutter/material.dart';
class AppProvider extends ChangeNotifier {
  int _navbarIndex;
  AppProvider(this._navbarIndex);
  int get navbarIndex => _navbarIndex;

  void set navbarIndex(int index) {
    _navbarIndex = index;
  }
}