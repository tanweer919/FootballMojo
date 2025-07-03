import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../commons/custom_icons.dart';
import '../models/Score.dart';
import '../Provider/MatchEventViewModel.dart';
import '../Provider/ThemeProvider.dart';

class Scorer extends StatefulWidget {
  Score score;
  Scorer({required this.score});

  @override
  _ScorerState createState() => _ScorerState();
}

class _ScorerState extends State<Scorer> {
  @override
  void initState() {
    super.initState();
    final MatchEventViewModel initialState =
        Provider.of<MatchEventViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeModel, child) => Consumer<MatchEventViewModel>(
        builder: (context, model, child) {
          return (model.events != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 50,
                          minWidth: MediaQuery.of(context).size.width * 0.4),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getHomeGoals(
                              model: model, themeModel: themeModel),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                      child: Icon(
                        MyFlutterApp.football,
                        color: themeModel.appTheme == AppTheme.Light
                            ? Color(0XAA000000)
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 50,
                          minWidth: MediaQuery.of(context).size.width * 0.4),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: getAwayGoals(
                              model: model, themeModel: themeModel),
                        ),
                      ),
                    )
                  ],
                )
              : Shimmer.fromColors(
                  baseColor: themeModel.appTheme == AppTheme.Light
                      ? Colors.grey[300]!
                      : Colors.grey[700]!,
                  highlightColor: themeModel.appTheme == AppTheme.Light
                      ? Colors.grey[100]!
                      : Colors.grey[600]!,
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
        },
      ),
    );
  }

  List<Widget> getHomeGoals(
      {required MatchEventViewModel model, required ThemeProvider themeModel}) {
    final List<Widget> homeTeamGoals = model.events
        .where((event) =>
            (event.team == widget.score.homeTeam && event.type == "Goal"))
        .map((event) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          "${event.player1} ${event.minute}'${(event.detail == "Penalty") ? "(P)" : (event.detail == "Own Goal") ? "(OG)" : ""}",
          style: TextStyle(
              fontSize: 14,
              color: themeModel.appTheme == AppTheme.Light
                  ? Color(0XAA000000)
                  : Colors.white),
          textAlign: TextAlign.left,
        ),
      );
    }).toList();
    return (homeTeamGoals.length > 0) ? homeTeamGoals : [Container()];
  }

  List<Widget> getAwayGoals(
      {required MatchEventViewModel model, required ThemeProvider themeModel}) {
    final List<Widget> awayTeamGoals = model.events
        .where((event) =>
            (event.team == widget.score.awayTeam && event.type == "Goal"))
        .map((event) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          "${event.player1} ${event.minute}'${(event.detail == "Penalty") ? "(P)" : (event.detail == "Own Goal") ? "(OG)" : ""}",
          style: TextStyle(
              fontSize: 14,
              color: themeModel.appTheme == AppTheme.Light
                  ? Color(0XAA000000)
                  : Colors.white),
          textAlign: TextAlign.right,
        ),
      );
    }).toList();
    return (awayTeamGoals.length > 0) ? awayTeamGoals : [Container()];
  }
}
