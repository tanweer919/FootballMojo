import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import '../services/GetItLocator.dart';
import 'package:provider/provider.dart';
import '../models/MatchStat.dart';
import 'package:sportsmojo/Provider/MatchStatViewModel.dart';
import '../commons/custom_icons.dart';
import '../models/Score.dart';
import '../services/StatService.dart';
import '../Provider/ThemeProvider.dart';

class Stats extends StatefulWidget {
  final Score score;
  Stats({this.score});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  void initState() {
    super.initState();
    final MatchStatViewModel initialState = Provider.of<MatchStatViewModel>(context, listen: false);
    if(initialState.stats == null) {
      initialState.loadStats(fixtureId: widget.score.id);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeModel, child) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<MatchStatViewModel>(
            builder: (context, model, child) {
              if(model != null && model.stats != null) {
                final stats = model.stats;
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 25,
                            child: CachedNetworkImage(
                                imageUrl: widget.score.homeTeamLogo,
                                placeholder: (BuildContext context, String url) =>
                                    Icon(MyFlutterApp.football))),
                        Text('Team Stats'),
                        Container(
                            height: 25,
                            child: CachedNetworkImage(
                                imageUrl: widget.score.awayTeamLogo,
                                placeholder: (BuildContext context, String url) =>
                                    Icon(MyFlutterApp.football)))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].totalShots}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Shots',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].totalShots}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].shotsOnTarget}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Shots on target',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].shotsOnTarget}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].possession}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Possession',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].possession}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].totalPasses}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Total Passes',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].totalPasses}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].accuratePasses}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Accurate Passes',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].accuratePasses}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].fouls}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Fouls',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].fouls}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].yellowCards}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Yellow Cards',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].yellowCards}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].redCards}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Red Cards',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].redCards}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].offsides}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Offsides',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].offsides}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].corners}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Corners',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].corners}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${stats["home"].saves}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Saves',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${stats["away"].saves}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
              else {
                return themeModel.appTheme == AppTheme.Light ? PKCardPageSkeleton(
                  totalLines: 10,
                ) : PKDarkCardPageSkeleton(
                  totalLines: 10,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
