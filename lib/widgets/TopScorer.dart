import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import '../models/Player.dart';
import '../Provider/AppProvider.dart';
import 'LeagueDropdown.dart';
import '../constants.dart';

class TopScorers extends StatefulWidget {
  @override
  _TopScorersState createState() => _TopScorersState();
}

class _TopScorersState extends State<TopScorers> {
  @override
  void initState() {
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.topScorers == null) {
      if (appProvider.selectedLeague == null) {
        appProvider.loadTopScorers();
      } else {
        appProvider.loadTopScorers(leagueName: appProvider.selectedLeague);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (context, model, child) => SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: LeagueDropdown(
                          items: getLeagueItems(),
                          selectedLeague: model.selectedLeague,
                          backgroundColor: Color(0xfffafafa),
                          fontColor: Colors.black,
                          purpose: "topscorer",
                        ),
                      ),
                      model.topScorers != null
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: model.topScorers.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Column(
                                          children: <Widget>[
                                            tableHeader(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: tableRow(
                                                  model.topScorers[index]),
                                            )
                                          ],
                                        );
                                      }
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child:
                                            tableRow(model.topScorers[index]),
                                      );
                                    }),
                              ),
                            )
                          : PKCardPageSkeleton(
                              totalLines: 15,
                            ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget tableHeader() {
    return Row(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width * 0.07, child: Text(' ')),
        Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Text(
              'Player',
              style: TextStyle(fontSize: 15, color: Color(0X8A000000)),
              textAlign: TextAlign.left,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.21,
            child: Text(
              'Goals(P)',
              style: TextStyle(fontSize: 15, color: Color(0X8A000000)),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.21,
            child: Text(
              'Assists',
              style: TextStyle(fontSize: 15, color: Color(0X8A000000)),
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  Widget tableRow(Player topScorer) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.07,
          child: Text(
            '${topScorer.rank}.',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.43,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Container(
                  width: 30,
                  child: CachedNetworkImage(
                      imageUrl: topScorer.photoUrl,
                      placeholder: (BuildContext context, String url) =>
                          Image.asset('assets/images/user-placeholder.jpg')),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      '${topScorer.name}',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflowReplacement: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          '${topScorer.name}',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Text('${topScorer.teamName}', style: TextStyle(fontSize: 13, color: Color(0X8A000000)),)
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            '${topScorer.goals}(${topScorer.penaltyGoals})',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            '${topScorer.assists}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
