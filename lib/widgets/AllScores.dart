import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../models/Score.dart';
import '../commons/ScoreCard.dart';
import '../services/GetItLocator.dart';
import '../Provider/AllScoresViewModel.dart';

class AllScores extends StatefulWidget {
  @override
  _AllScoresState createState() => _AllScoresState();
}

class _AllScoresState extends State<AllScores> {
  ScrollController _scrollController = ScrollController();
  int _totalNoOfScores;
  AllScoresViewModel _viewModel;
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
    if (_totalNoOfScores > 10) {
      _viewModel = locator<AllScoresViewModel>(
          param1: _leagueWiseScores.sublist(0, 10), param2: 9);
    } else {
      _viewModel = locator<AllScoresViewModel>(
          param1: _leagueWiseScores, param2: _totalNoOfScores - 1);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        final AllScoresViewModel allScoresProvider =
            Provider.of<AllScoresViewModel>(context, listen: false);
        if ((_scrollController.position.maxScrollExtent -
                    _scrollController.position.pixels ==
                0.0) &&
            allScoresProvider.lastRetrievedIndex < _totalNoOfScores - 1) {
          _getMoreScores(allScoresProvider, _leagueWiseScores);
        }
      });
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
      child: ChangeNotifierProvider<AllScoresViewModel>(
        create: (context) => _viewModel,
        child: Consumer<AllScoresViewModel>(
          builder: (context, model, child) => Container(
            margin: EdgeInsets.only(top: 30.0),
            child: model.allScores != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.lastRetrievedIndex + 2,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == model.lastRetrievedIndex + 1) {
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
                              label: Text(
                                'Swipe up to load more',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        );
                      }
                      final Score score = model.allScores[index];
                      return ScoreCard(
                        score: score,
                      );
                    })
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return PKCardSkeleton(
                        isCircularImage: true,
                        isBottomLinesActive: true,
                      );
                    }),
          ),
        ),
      ),
    );
  }

  void _getMoreScores(
      AllScoresViewModel allScoresProvider, List<Score> scores) {
    setState(() {
      if (allScoresProvider.lastRetrievedIndex < (_totalNoOfScores - 11)) {
        allScoresProvider.allScores.addAll(scores.sublist(
            allScoresProvider.lastRetrievedIndex + 1,
            allScoresProvider.lastRetrievedIndex + 11));
        allScoresProvider.lastRetrievedIndex += 10;
      } else {
        allScoresProvider.allScores
            .addAll(scores.sublist(allScoresProvider.lastRetrievedIndex + 1));
        allScoresProvider.lastRetrievedIndex = _totalNoOfScores - 1;
      }
    });
  }
}
