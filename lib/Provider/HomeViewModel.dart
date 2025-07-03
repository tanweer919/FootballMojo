import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// A view model class that manages the home screen's state.
///
/// This class handles:
/// - Carousel index state
/// - State persistence
/// - State validation
class HomeViewModel extends ChangeNotifier {
  static const String _carouselIndexKey = 'home_carousel_index';
  final SharedPreferences _prefs;
  bool _isInitialized = false;

  /// Creates a new instance of [HomeViewModel].
  ///
  /// The [carouselIndex] parameter is the initial index of the carousel.
  /// The [prefs] parameter is used for state persistence.
  HomeViewModel({
    required SharedPreferences prefs,
    int carouselIndex = 0,
  })  : _prefs = prefs,
        _carouselIndex = carouselIndex {
    _initialize();
  }

  int _carouselIndex;

  /// Gets the current carousel index.
  int get carouselIndex => _carouselIndex;

  /// Sets the carousel index and persists the change.
  ///
  /// The [index] parameter must be non-negative.
  void set carouselIndex(int index) {
    assert(index >= 0, 'Carousel index must be non-negative');
    if (_carouselIndex != index) {
      _carouselIndex = index;
      _saveState();
      notifyListeners();
    }
  }

  /// Initializes the view model by loading saved state.
  Future<void> _initialize() async {
    if (_isInitialized) {
      developer.log('HomeViewModel already initialized');
      return;
    }

    try {
      developer.log('Initializing HomeViewModel');
      await _loadState();
      _isInitialized = true;
      developer.log('HomeViewModel initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing HomeViewModel',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Loads the saved state from persistent storage.
  Future<void> _loadState() async {
    try {
      _carouselIndex = _prefs.getInt(_carouselIndexKey) ?? 0;
      developer.log('Loaded state: carouselIndex=$_carouselIndex');
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
      await _prefs.setInt(_carouselIndexKey, _carouselIndex);
      developer.log('Saved state: carouselIndex=$_carouselIndex');
    } catch (e, stackTrace) {
      developer.log(
        'Error saving state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void dispose() {
    _isInitialized = false;
    super.dispose();
  }
}
