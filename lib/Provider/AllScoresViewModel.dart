import 'package:flutter/material.dart';
import '../models/Score.dart';
class AllScoresViewModel extends ChangeNotifier {
  List<Score> _scores;
  int _lastRetrievedIndex;

  AllScoresViewModel(_scores, _lastRetrievedIndex);


  List<Score> get allScores => _scores;

  void set allScores(List<Score> scores) {
    _scores = scores;
    notifyListeners();
  }

  int get lastRetrievedIndex => _lastRetrievedIndex;

  void set lastRetrievedIndex(int index) {
    _lastRetrievedIndex = index;
    notifyListeners();
  }


}