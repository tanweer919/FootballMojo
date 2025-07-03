import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sportsmojo/models/MatchEvent.dart';
import 'package:sportsmojo/services/MatchEventService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// A view model class that manages match events state.
///
/// This class handles:
/// - Match events state
/// - State persistence
/// - State validation
/// - Event loading
class MatchEventViewModel extends ChangeNotifier {
  static const String _eventsKey = 'match_events';
  final MatchEventService _eventService;
  final SharedPreferences _prefs;
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  /// Creates a new instance of [MatchEventViewModel].
  ///
  /// The [events] parameter is the initial list of match events.
  /// The [eventService] parameter is used for fetching events.
  /// The [prefs] parameter is used for state persistence.
  MatchEventViewModel({
    required MatchEventService eventService,
    required SharedPreferences prefs,
    List<MatchEvent>? events,
  })  : _eventService = eventService,
        _prefs = prefs,
        _events = events ?? [] {
    _initialize();
  }

  List<MatchEvent> _events;

  /// Gets the current list of match events.
  List<MatchEvent> get events => List.unmodifiable(_events);

  /// Gets whether events are currently being loaded.
  bool get isLoading => _isLoading;

  /// Gets the current error message, if any.
  String? get error => _error;

  /// Sets the list of match events and persists the change.
  void set events(List<MatchEvent> newEvents) {
    if (!listEquals(_events, newEvents)) {
      _events = newEvents;
      _saveState();
      notifyListeners();
    }
  }

  /// Initializes the view model by loading saved state.
  Future<void> _initialize() async {
    if (_isInitialized) {
      developer.log('MatchEventViewModel already initialized');
      return;
    }

    try {
      developer.log('Initializing MatchEventViewModel');
      await _loadState();
      _isInitialized = true;
      developer.log('MatchEventViewModel initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing MatchEventViewModel',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Loads the saved state from persistent storage.
  Future<void> _loadState() async {
    try {
      final eventsJson = _prefs.getStringList(_eventsKey);
      if (eventsJson != null) {
        _events =
            eventsJson.map((json) => MatchEvent.fromJsonString(json)).toList();
        developer.log('Loaded ${_events.length} events from storage');
      }
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
      final eventsJson = _events.map((event) => event.toJsonString()).toList();
      await _prefs.setStringList(_eventsKey, eventsJson);
      developer.log('Saved ${_events.length} events to storage');
    } catch (e, stackTrace) {
      developer.log(
        'Error saving state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Loads match events for a specific fixture.
  ///
  /// The [fixtureId] parameter is the ID of the fixture to load events for.
  Future<void> loadEvents({required int fixtureId}) async {
    if (_isLoading) {
      developer.log('Already loading events');
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      developer.log('Loading events for fixture $fixtureId');
      final events = await _eventService.fetchEvents(fixtureId: fixtureId);
      if (events != null) {
        _events = events;
        await _saveState();
        developer.log('Loaded ${events.length} events for fixture $fixtureId');
      } else {
        _events = [];
        developer.log('No events found for fixture $fixtureId');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error loading events for fixture $fixtureId',
        error: e,
        stackTrace: stackTrace,
      );
      _error = 'Failed to load events: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isInitialized = false;
    _events.clear();
    super.dispose();
  }
}
