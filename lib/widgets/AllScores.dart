import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../models/Score.dart';
import '../commons/ScoreCard.dart';
import 'SettingsDialog.dart';
import '../constants.dart';
import '../widgets/LeagueDropdown.dart';
import '../Provider/AppProvider.dart';

class AllScores extends StatefulWidget {
  @override
  _AllScoresState createState() => _AllScoresState();
}

class _AllScoresState extends State<AllScores> {
  ScrollController _scrollController = ScrollController();
  int _lastRetrievedLindex;
  int _totalNoOfScores;
  List<Score> _scores;
  List<DropdownMenuItem> leaguesItems = leagues.entries
      .map<DropdownMenuItem<String>>((entry) => DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.key),
          ))
      .toList();

  @override
  void initState() {
    super.initState();
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.leagueWiseScores == null) {
      if (appProvider.selectedLeague == null) {
        appProvider.loadLeagueWiseScores().whenComplete(() {
          _setScores(appProvider);
        });
      } else {
        appProvider
            .loadLeagueWiseScores(leagueName: appProvider.selectedLeague)
            .whenComplete(() {
          _setScores(appProvider);
        });
      }
    } else {
      _setScores(appProvider);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
          builder: (context, model, child) => SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            LeagueDropdown(
                              items: leaguesItems,
                              selectedLeague: model.selectedLeague,
                              backgroundColor: Color(0xfffafafa),
                              fontColor: Colors.black,
                              purpose: "score",
                            ),
                            FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.filter_list),
                                  Text('Filter')
                                ],
                              ),
                              color: Color(0xfffafafa),
                              onPressed: () {
                                onSettingPressed();
                              },
                            )
                          ],
                        ),
                      ),
                      (model.leagueWiseScores != null && _scores != null)
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _lastRetrievedLindex + 2,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == _lastRetrievedLindex + 1) {
                                  return index == _totalNoOfScores
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: SizedBox(
                                            height: 40,
                                            child: Chip(
                                              elevation: 2,
                                              backgroundColor: Colors.white,
                                              avatar: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Icon(Icons.arrow_upward),
                                              ),
                                              label: Text(
                                                'Swipe up to load more',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                        );
                                }
                                final Score score = _scores[index];
                                if (index != 0 &&
                                    dayDifference(
                                            date_time1: score.date_time,
                                            date_time2:
                                                _scores[index - 1].date_time) ==
                                        0) {
                                  return ScoreCard(
                                    score: score,
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Text(
                                            '${convertDateTime(date_time: score.date_time)}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        ScoreCard(
                                          score: score,
                                        )
                                      ],
                                    ),
                                  );
                                }
                              })
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return PKCardSkeleton(
                                  isCircularImage: true,
                                  isBottomLinesActive: true,
                                );
                              }),
                    ],
                  ),
                ),
              ));
  }

  void _getMoreScores(List<Score> scores) {
    setState(() {
      if (_lastRetrievedLindex < (_totalNoOfScores - 11)) {
        _scores.addAll(scores.sublist(
            _lastRetrievedLindex + 1, _lastRetrievedLindex + 11));
        _lastRetrievedLindex += 10;
      } else {
        _scores.addAll(scores.sublist(_lastRetrievedLindex + 1));
        _lastRetrievedLindex = _totalNoOfScores - 1;
      }
    });
  }

  void _setScores(AppProvider appProvider) {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    final List<Score> allScores = filterScores(
        scores: appProvider.leagueWiseScores,
        after: appProvider.startDate,
        before: appProvider.endDate);
    _totalNoOfScores = allScores.length;
    setState(() {
      if (_totalNoOfScores > 10) {
        _scores = allScores.sublist(0, 10);
        _lastRetrievedLindex = 9;
      } else {
        _scores = allScores;
        _lastRetrievedLindex = _totalNoOfScores - 1;
      }
    });
    _scrollController.addListener(() {
      if ((_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels ==
              0.0) &&
          _lastRetrievedLindex < _totalNoOfScores - 1) {
        _getMoreScores(allScores);
      }
    });
  }

  void onSettingPressed() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: SettingsDialog(),
          );
        });
  }

  String convertDateTime({DateTime date_time}) {
    int dayDifferenceCount =
        dayDifference(date_time1: DateTime.now(), date_time2: date_time);
    if (dayDifferenceCount == 0) {
      return 'Today';
    } else if (dayDifferenceCount == 1) {
      return 'Yesterday';
    } else if (dayDifferenceCount == -1) {
      return 'Tomorrow';
    } else {
      return DateFormat('E, d MMMM').format(date_time);
    }
  }
}
