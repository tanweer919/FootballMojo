import 'package:flutter/material.dart';

enum AppTheme {Light, Dark}
class ThemeProvider extends ChangeNotifier {
  AppTheme _appTheme;
  ThemeProvider({required AppTheme appTheme}) : _appTheme = appTheme;
  AppTheme get appTheme => _appTheme;

  void set appTheme(AppTheme theme) {
    _appTheme = theme;
    notifyListeners();
  }
}