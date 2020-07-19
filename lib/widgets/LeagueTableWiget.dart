import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Provider/AppProvider.dart';
import '../commons/custom_icons.dart';
import '../constants.dart';
import '../widgets/LeagueDropdown.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LeagueTableWidget extends StatefulWidget {
  @override
  _LeagueTableWidgetState createState() => _LeagueTableWidgetState();
}

class _LeagueTableWidgetState extends State<LeagueTableWidget> {
  List<DropdownMenuItem> leaguesItems = leagues.entries
      .map<DropdownMenuItem<String>>((entry) => DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.key),
          ))
      .toList();

  @override
  void initState() {
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.leagueTableEntries == null) {
      if(appProvider.selectedLeague == null) {
        appProvider.loadLeagueTable();
      }
      else {
        appProvider.loadLeagueTable(leagueName: appProvider.selectedLeague);
      }
    }
    super.initState();
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
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: LeagueDropdown(
                                items: leaguesItems,
                                selectedLeague: model.selectedLeague,
                                backgroundColor: Color(0xfffafafa),
                                fontColor: Colors.black,
                                purpose: "table",
                              ),
                            ),
                            model.leagueTableEntries != null
                                ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1.3,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            model.leagueTableEntries.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0) {
                                            return Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.07,
                                                        child: Text(' ')),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        child: Text(
                                                          'Club',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.left,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'MP',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'W',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'L',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'D',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'Pts.',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'GF',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'GA',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          'GD',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0X8A000000)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ))
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.07,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].position}.',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              width: 16,
                                                              child: CachedNetworkImage(
                                                                  imageUrl: model
                                                                      .leagueTableEntries[
                                                                          index]
                                                                      .teamLogo,
                                                                  placeholder: (BuildContext
                                                                              context,
                                                                          String
                                                                              url) =>
                                                                      Icon(MyFlutterApp
                                                                          .football, size: 16,),),
                                                            ),
                                                            Expanded(
                                                              child: AutoSizeText(
                                                                '${model.leagueTableEntries[index].teamName}',
                                                                style: TextStyle(
                                                                    fontSize: 15),
                                                                textAlign:
                                                                TextAlign.left,
                                                                maxLines: 1,
                                                                overflowReplacement:
                                                                FittedBox(
                                                                  fit: BoxFit.fitWidth,
                                                                  child: Text(
                                                                    '${model.leagueTableEntries[index].teamName}',
                                                                    style: TextStyle(
                                                                        fontSize: 15),
                                                                    textAlign:
                                                                    TextAlign.left,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].matchesPlayed}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].wins}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].draws}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].loses}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].points}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].goalsFor}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].goalsAgainst}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          '${model.leagueTableEntries[index].goalsFor - model.leagueTableEntries[index].goalsAgainst}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.07,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].position}.',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 16,
                                                        child: CachedNetworkImage(
                                                            imageUrl: model
                                                                .leagueTableEntries[
                                                                    index]
                                                                .teamLogo,
                                                            placeholder: (BuildContext
                                                                        context,
                                                                    String
                                                                        url) =>
                                                                Icon(MyFlutterApp
                                                                    .football, size: 16,)),
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          '${model.leagueTableEntries[index].teamName}',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 1,
                                                          overflowReplacement:
                                                              FittedBox(
                                                                fit: BoxFit.fitWidth,
                                                            child: Text(
                                                              '${model.leagueTableEntries[index].teamName}',
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                              textAlign:
                                                                  TextAlign.left,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].matchesPlayed}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].wins}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].draws}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].loses}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].points}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].goalsFor}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].goalsAgainst}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    '${model.leagueTableEntries[index].goalsFor - model.leagueTableEntries[index].goalsAgainst}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ) : PKCardPageSkeleton(
                              totalLines: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
            ));
  }
}
