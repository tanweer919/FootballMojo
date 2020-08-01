import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../models/Score.dart';
import '../commons/ScoreCard.dart';
import '../commons/NoContent.dart';
import '../Provider/ThemeProvider.dart';

class FavouriteScoresPast extends StatefulWidget {
  @override
  _FavouriteScoresPastState createState() => _FavouriteScoresPastState();
}

class _FavouriteScoresPastState extends State<FavouriteScoresPast> {
  ScrollController _scrollController = ScrollController();
  int _lastRetrievedLindex;
  int _totalNoOfScores;
  List<Score> _scores;
  @override
  void initState() {
    super.initState();
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.favouriteTeamScores == null) {
      appProvider.loadFavouriteScores().whenComplete(() {
        _setScores(appProvider);
      });
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
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return RefreshIndicator(
        onRefresh: () async {
          await _handleRefresh(appProvider: appProvider);
        },
        child: Consumer<ThemeProvider>(
          builder: (context, themeModel, child) => SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              margin: EdgeInsets.only(top: 30.0),
              child: _scores != null
                  ? _totalNoOfScores > 0
                      ? scoreList()
                      : NoContent(
                          title: 'No matches found',
                          description:
                              'There are no past league matches matching your query',
                        )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return themeModel.appTheme == AppTheme.Light ? PKCardSkeleton(
                          isCircularImage: true,
                          isBottomLinesActive: true,
                        ) : PKDarkCardSkeleton(
                          isCircularImage: true,
                          isBottomLinesActive: true,
                        );
                      }),
            ),
          ),
        ));
  }

  Widget scoreList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _lastRetrievedLindex + 2,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          if (index == _lastRetrievedLindex + 1) {
            return index == _totalNoOfScores
                ? Container()
                : Padding(
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
                        label: Text(
                          'Swipe up to load more',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  );
          }
          final Score score = _scores[index];
          return ScoreCard(
            score: score,
          );
        });
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

  List<Score> _setScores(AppProvider appProvider) {
    List<Score> favouriteTeamScores = appProvider.favouriteTeamScores
        .where((score) =>
            score.date_time.difference(DateTime.now()).inSeconds <= 0)
        .toList();
    _totalNoOfScores = favouriteTeamScores.length;
    setState(() {
      if (_totalNoOfScores > 10) {
        _scores = favouriteTeamScores.sublist(0, 10);
        _lastRetrievedLindex = 9;
      } else {
        _scores = favouriteTeamScores;
        _lastRetrievedLindex = _totalNoOfScores - 1;
      }
    });
    _scrollController.addListener(() {
      if ((_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels ==
              0.0) &&
          _lastRetrievedLindex < _totalNoOfScores - 1) {
        _getMoreScores(favouriteTeamScores);
      }
    });
  }

  Future<void> _handleRefresh({AppProvider appProvider}) async {
    await appProvider.loadFavouriteScores();
    Navigator.of(context).pushReplacementNamed('/score');
  }
}
