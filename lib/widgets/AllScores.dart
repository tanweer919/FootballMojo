import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../models/Score.dart';
import '../commons/ScoreCard.dart';

class AllScores extends StatefulWidget {
  @override
  _AllScoresState createState() => _AllScoresState();
}

class _AllScoresState extends State<AllScores> {
  ScrollController _scrollController = ScrollController();
  int _lastRetrievedLindex = 9;
  int _totalNoOfScores;
  List<Score> _scores;
  @override
  void initState() {
    super.initState();
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.leagueWiseScores == null) {
      appProvider.loadLeagueWiseScores();
    }
    final List<Score> _leagueWiseScores = appProvider.leagueWiseScores;
    _totalNoOfScores = _leagueWiseScores.length;
    _scrollController.addListener(() {
      if ((_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels ==
              0.0) &&
          _lastRetrievedLindex < _totalNoOfScores - 1) {
        _getMoreScores(_leagueWiseScores);
      }
    });
    setState(() {
      if (_totalNoOfScores > 10) {
        _scores = _leagueWiseScores.sublist(0, 10);
      } else {
        _scores = _leagueWiseScores;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        margin: EdgeInsets.only(top: 30.0),
        child: _scores != null
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _lastRetrievedLindex + 2,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if(index == _lastRetrievedLindex + 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          height: 40,
                          child: Chip(
                            elevation: 2,
                            backgroundColor: Colors.white,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.arrow_upward),
                            ),
                            label: Text('Swipe up to load more', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                          ),
                        ),
                      );
                  }
                  final Score score = _scores[index];
                  return ScoreCard(
                    score: score,
                  );
                })
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return PKCardSkeleton(
                    isCircularImage: true,
                    isBottomLinesActive: true,
                  );
                }),
      ),
    );
  }

  void _getMoreScores(List<Score> scores) {
    setState(() {
      if (_lastRetrievedLindex < (_totalNoOfScores - 11)) {
        _scores.addAll(
            scores.sublist(_lastRetrievedLindex + 1 , _lastRetrievedLindex + 11));
        _lastRetrievedLindex += 10;
      } else {
        _scores.addAll(scores.sublist(_lastRetrievedLindex + 1));
        _lastRetrievedLindex = _totalNoOfScores - 1;
      }
    });
  }
}
