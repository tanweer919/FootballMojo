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
  final GlobalKey<AnimatedListState> _allScoresListlKey = GlobalKey();
  int _lastRetrievedLindex = 9;
  int _totalNoOfScores;
  int _listInitalCount = 11;
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
        print('${_scrollController.position.maxScrollExtent -
            _scrollController.position.pixels}');
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
            ? AnimatedList(
                key: _allScoresListlKey,
                shrinkWrap: true,
                initialItemCount: _listInitalCount,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index,
                    Animation<double> animation) {
                  if (index < _listInitalCount - 1) {
                    final Score score = _scores[index];
                    return SlideTransition(
                      position: Tween<Offset>(
                          begin: const Offset(-1, 0), end: Offset.zero)
                          .animate(animation),
                      child: ScoreCard(
                        score: score,
                      ),
                    );
                  }
                  return SizedBox(
                    height: 80,
                    child: SpinKitFadingCube(color: Theme.of(context).primaryColor, size: 50,),
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
        for (int i = 1; i <= 10; i++) {
          _allScoresListlKey.currentState.insertItem(_lastRetrievedLindex + i);
          _listInitalCount+=1;
        }
        _scores.addAll(
            scores.sublist(_lastRetrievedLindex + 1 , _lastRetrievedLindex + 11));
        _lastRetrievedLindex += 10;
      } else {
        for (int i = 1; i < (_totalNoOfScores - _lastRetrievedLindex); i++) {
          _allScoresListlKey.currentState.insertItem(_lastRetrievedLindex + i);
          _listInitalCount+=1;
        }
        _scores.addAll(scores.sublist(_lastRetrievedLindex + 1));
        _lastRetrievedLindex = _totalNoOfScores - 1;
      }
    });
  }
}
