import 'package:flutter/material.dart';
import '../models/Score.dart';
class AllScoresViewModel extends ChangeNotifier {
  String _selectedLeague;

  AllScoresViewModel(this._selectedLeague);


  String get selectedLeague => _selectedLeague;

  void set selectedLeague(String league) {
    _selectedLeague = league;
    notifyListeners();
  }

}