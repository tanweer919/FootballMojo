import 'package:flutter/material.dart';

class GlobalKeys {
  static final GlobalKey carouselKey = GlobalKey(debugLabel: 'carouselKey');
  static final GlobalKey matchCardKey = GlobalKey(debugLabel: 'matchCardKey');
  static final GlobalKey allNewsCardKey = GlobalKey(debugLabel: 'allNewsCardKey');
  static final GlobalKey homeScreenKey = GlobalKey(debugLabel: 'homeScreenKey');
  static final GlobalKey scoreScreenKey = GlobalKey(debugLabel: 'scoreScreenKey');
  static final GlobalKey leagueScreenKey = GlobalKey(debugLabel: 'leagueScreenKey');
  static final GlobalKey newsScreenKey = GlobalKey(debugLabel: 'newsScreenKey');
  static final GlobalKey dashboardScreenKey = GlobalKey(debugLabel: 'dashboardScreenKey');
  static final List<GlobalKey> globalKeys = [
    carouselKey,
    matchCardKey,
    allNewsCardKey,
    homeScreenKey,
    scoreScreenKey,
    leagueScreenKey,
    newsScreenKey,
    dashboardScreenKey
  ];
}
