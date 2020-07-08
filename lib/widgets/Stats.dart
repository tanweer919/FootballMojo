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

class Stats extends StatefulWidget {
  final Score score;
  Stats({this.score});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  StatService _statService = locator<StatService>();
  Future<Map<String, MatchStat>> futureMatchStat;
  @override
  void initState() {
    super.initState();
    setState(() {
      futureMatchStat = _statService.fetchStats(id: widget.score.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<Map<String, MatchStat>>(
          future: futureMatchStat,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final stats = snapshot.data;
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
                        '${stats["away"].accuratePasses}%',
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PKCardPageSkeleton(
              totalLines: 10,
            );
          }
        }),
      ),
    );
  }
}
