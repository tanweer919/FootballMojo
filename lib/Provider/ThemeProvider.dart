import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// Enum representing the available app themes.
enum AppTheme {
  /// Light theme mode.
  Light,

  /// Dark theme mode.
  Dark,
}

/// A provider class that manages the app's theme state.
///
/// This class handles:
/// - Theme state management
/// - Theme persistence
/// - Theme mode conversion
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme';
  final SharedPreferences _prefs;
  AppTheme _appTheme;
  bool _isInitialized = false;

  /// Creates a new [ThemeProvider] instance.
  ///
  /// The [appTheme] parameter is the initial theme.
  /// The [prefs] parameter is used for theme persistence.
  ThemeProvider({
    required AppTheme appTheme,
    required SharedPreferences prefs,
  })  : _appTheme = appTheme,
        _prefs = prefs {
    _initialize();
  }

  /// The current app theme.
  AppTheme get appTheme => _appTheme;

  /// Sets the app theme and persists it.
  ///
  /// This will notify all listeners of the change.
  set appTheme(AppTheme theme) {
    if (_appTheme != theme) {
      _appTheme = theme;
      _saveTheme();
      notifyListeners();
    }
  }

  /// Converts the current [AppTheme] to a [ThemeMode].
  ThemeMode get themeMode {
    switch (_appTheme) {
      case AppTheme.Light:
        return ThemeMode.light;
      case AppTheme.Dark:
        return ThemeMode.dark;
    }
  }

  /// Initializes the theme provider by loading the saved theme.
  Future<void> _initialize() async {
    if (_isInitialized) {
      developer.log('ThemeProvider already initialized');
      return;
    }

    try {
      developer.log('Initializing ThemeProvider');
      await _loadTheme();
      _isInitialized = true;
      developer.log('ThemeProvider initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing ThemeProvider',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Loads the saved theme from persistent storage.
  Future<void> _loadTheme() async {
    try {
      final themeIndex = _prefs.getInt(_themeKey);
      if (themeIndex != null) {
        _appTheme = AppTheme.values[themeIndex];
        developer.log('Loaded theme: $_appTheme');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error loading theme',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Saves the current theme to persistent storage.
  Future<void> _saveTheme() async {
    try {
      await _prefs.setInt(_themeKey, _appTheme.index);
      developer.log('Saved theme: $_appTheme');
    } catch (e, stackTrace) {
      developer.log(
        'Error saving theme',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Toggles between light and dark themes.
  void toggleTheme() {
    appTheme = _appTheme == AppTheme.Light ? AppTheme.Dark : AppTheme.Light;
  }

  @override
  void dispose() {
    _isInitialized = false;
    super.dispose();
  }
}
