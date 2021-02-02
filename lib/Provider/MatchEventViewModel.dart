import 'package:flutter/material.dart';
import 'package:sportsmojo/models/MatchEvent.dart';
import 'package:sportsmojo/services/MatchEventService.dart';
import '../models/MatchStat.dart';
import '../services/MatchEventService.dart';
import '../services/GetItLocator.dart';
class MatchEventViewModel extends ChangeNotifier {
  List<MatchEvent> _events;
  MatchEventViewModel(this._events);
  MatchEventService _eventService = locator<MatchEventService>();

  Future<void> loadEvents({@required int fixtureId}) async{
    _events =  await _eventService.fetchEvents(fixtureId: fixtureId);
    notifyListeners();
  }

  List<MatchEvent> get events => _events;
  void set stats(List<MatchEvent> events) {
    _events = events;
    notifyListeners();
  }
}