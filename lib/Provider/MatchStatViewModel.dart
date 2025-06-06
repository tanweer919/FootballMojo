import 'package:flutter/material.dart';
import '../models/MatchStat.dart';
import '../services/StatService.dart';
import '../services/GetItLocator.dart';
class MatchStatViewModel extends ChangeNotifier {
  Map<String, MatchStat> _stats;
  MatchStatViewModel({required Map<String, MatchStat> stats}) : _stats = stats;
  final StatService _statService = locator<StatService>();

  Future<void> loadStats({required int fixtureId}) async {
    // Assuming _statService.fetchStats returns a non-nullable Map<String, MatchStat>
    _stats = await _statService.fetchStats(fixtureId: fixtureId);
    notifyListeners();
  }

  Map<String, MatchStat> get stats => _stats;
  void set stats(Map<String, MatchStat> stats) {
    _stats = stats;
    notifyListeners();
  }
}