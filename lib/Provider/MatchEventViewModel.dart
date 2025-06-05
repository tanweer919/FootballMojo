import 'package:flutter/material.dart';
import 'package:sportsmojo/models/MatchEvent.dart';
import 'package:sportsmojo/services/MatchEventService.dart';
import '../services/GetItLocator.dart';
class MatchEventViewModel extends ChangeNotifier {
  List<MatchEvent> _events;
  MatchEventViewModel({required List<MatchEvent> events}) : _events = events;
  final MatchEventService _eventService = locator<MatchEventService>();

  Future<void> loadEvents({required int fixtureId}) async {
    // Assuming _eventService.fetchEvents returns a non-nullable List<MatchEvent>
    _events = await _eventService.fetchEvents(fixtureId: fixtureId);
    notifyListeners();
  }

  List<MatchEvent> get events => _events;
  // Renamed setter from 'stats' to 'events' for clarity
  void set events(List<MatchEvent> newEvents) {
    _events = newEvents;
    notifyListeners();
  }
}