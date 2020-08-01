import 'package:flutter/material.dart';

enum AppTheme {Light, Dark}
class ThemeProvider extends ChangeNotifier {
  AppTheme _appTheme;
  ThemeProvider(this._appTheme);
  AppTheme get appTheme => _appTheme;

  void set appTheme(AppTheme theme) {
    _appTheme = theme;
    notifyListeners();
  }
}