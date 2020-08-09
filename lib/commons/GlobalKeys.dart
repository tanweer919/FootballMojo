import 'package:flutter/material.dart';

class GlobalKeys {
  static final GlobalKey carouselKey = GlobalKey(debugLabel: 'carouselKey');
  static final GlobalKey matchCardKey = GlobalKey(debugLabel: 'matchCardKey');
  static final GlobalKey allNewsCardKey = GlobalKey(debugLabel: 'allNewsCardKey');
  static final List<GlobalKey> globalKeys = [
    carouselKey,
    matchCardKey,
    allNewsCardKey,
  ];
}
