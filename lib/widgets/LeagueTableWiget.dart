import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportsmojo/commons/NoContent.dart';
import 'package:sportsmojo/models/LeagueTable.dart';
import '../Provider/AppProvider.dart';
import '../commons/custom_icons.dart';
import '../constants.dart';
import '../widgets/LeagueDropdown.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Provider/ThemeProvider.dart';

class LeagueTableWidget extends StatefulWidget {
  @override
  _LeagueTableWidgetState createState() => _LeagueTableWidgetState();
}

class _LeagueTableWidgetState extends State<LeagueTableWidget> {
  @override
  void initState() {
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.leagueTableEntries == null) {
      if (appProvider.selectedLeague == null) {
        appProvider.loadLeagueTable();
      } else {
        appProvider.loadLeagueTable(leagueName: appProvider.selectedLeague);
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
        builder: (context, model, child) => Consumer<ThemeProvider>(
            builder: (context, themeModel, child) => SingleChildScrollView(
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
                              backgroundColor: themeModel.appTheme == AppTheme.Light ? Color(0xfffafafa) : Color(0xff1d1d1d),
                              fontColor: themeModel.appTheme == AppTheme.Light ? Colors.black : Colors.white,
                              purpose: "table",
                            ),
                          ),
                          model.leagueTableEntries != null
                              ? (model.leagueTableEntries.length > 0
                                  ? Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1.3,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: model
                                                    .leagueTableEntries.length,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index == 0) {
                                                    return Column(
                                                      children: <Widget>[
                                                        tableHeader(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: tableRow(model
                                                                  .leagueTableEntries[
                                                              index]),
                                                        )
                                                      ],
                                                    );
                                                  }
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0),
                                                    child: tableRow(model
                                                            .leagueTableEntries[
                                                        index]),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    )
                                  : NoContent(
                                      title: 'No league table found',
                                      description:
                                          'There are no league table matching your query'))
                              : themeModel.appTheme == AppTheme.Light ? PKCardPageSkeleton(
                                  totalLines: 15,
                                ) : PKDarkCardPageSkeleton(
                            totalLines: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                )));
  }

  Widget tableHeader() {
    return Row(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width * 0.07, child: Text(' ')),
        Container(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              'Club',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.left,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'MP',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'W',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'L',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'D',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'Pts.',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'GF',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'GA',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              'GD',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            ))
      ],
    );
  }

  Widget tableRow(LeagueTableEntry leagueTableEntry) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.07,
          child: Text(
            '${leagueTableEntry.position}.',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 16,
                child: CachedNetworkImage(
                    imageUrl: leagueTableEntry.teamLogo,
                    placeholder: (BuildContext context, String url) => Icon(
                          MyFlutterApp.football,
                          size: 16,
                        )),
              ),
              Expanded(
                child: AutoSizeText(
                  '${leagueTableEntry.teamName}',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflowReplacement: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '${leagueTableEntry.teamName}',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.matchesPlayed}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.wins}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.draws}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.loses}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.points}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.goalsFor}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.goalsAgainst}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            '${leagueTableEntry.goalsFor - leagueTableEntry.goalsAgainst}',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
