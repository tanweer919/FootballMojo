import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:sportsmojo/Provider/HomeViewModel.dart';
import '../models/MatchEvent.dart';
import '../commons/custom_icons.dart';
import '../models/Score.dart';
import '../Provider/MatchEventViewModel.dart';

class Scorer extends StatefulWidget {
  Score score;
  Scorer({this.score});

  @override
  _ScorerState createState() => _ScorerState();
}

class _ScorerState extends State<Scorer> {
  @override
  void initState() {
    super.initState();
    final MatchEventViewModel initialState =
        Provider.of<MatchEventViewModel>(context, listen: false);
    if (initialState.events == null) {
      initialState.loadEvents(fixtureId: widget.score.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchEventViewModel>(
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
                        children: getHomeGoals(model: model),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    child: Icon(
                      MyFlutterApp.football,
                      color: Color(0XAA000000),
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
                        children: getAwayGoals(model: model),
                      ),
                    ),
                  )
                ],
              )
            : Card(
          child: PKCardPageSkeleton(totalLines: 2,),
        );
      },
    );
  }

  List<Widget> getHomeGoals({MatchEventViewModel model}) {
    final List<Widget> homeTeamGoals = model.events
        .where((event) =>
            (event.team == widget.score.homeTeam && event.type == "Goal"))
        .map((event) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          "${event.player1} ${event.minute}'${(event.detail == "Penalty") ? "(P)" : (event.detail == "Own Goal") ? "(OG)" : ""}",
          style: TextStyle(fontSize: 14, color: Color(0XAA000000)),
          textAlign: TextAlign.left,
        ),
      );
    }).toList();
    return (homeTeamGoals.length > 0) ? homeTeamGoals : [Container()];
  }

  List<Widget> getAwayGoals({MatchEventViewModel model}) {
    final List<Widget> awayTeamGoals = model.events
        .where((event) =>
            (event.team == widget.score.awayTeam && event.type == "Goal"))
        .map((event) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          "${event.player1} ${event.minute}'${(event.detail == "Penalty") ? "(P)" : (event.detail == "Own Goal") ? "(OG)" : ""}",
          style: TextStyle(fontSize: 14, color: Color(0XAA000000)),
          textAlign: TextAlign.right,
        ),
      );
    }).toList();
    return (awayTeamGoals.length > 0) ? awayTeamGoals : [Container()];
  }
}
