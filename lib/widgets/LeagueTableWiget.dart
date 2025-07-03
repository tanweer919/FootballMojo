import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
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
  const LeagueTableWidget({Key? key}) : super(key: key);

  @override
  _LeagueTableWidgetState createState() => _LeagueTableWidgetState();
}

class _LeagueTableWidgetState extends State<LeagueTableWidget> {
  @override
  void initState() {
    super.initState();
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.selectedLeague != null) {
      appProvider.loadLeagueTable(leagueName: appProvider.selectedLeague!);
    }
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
            margin: const EdgeInsets.only(top: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: LeagueDropdown(
                      items: getLeagueItems()
                          .map((item) => DropdownMenuItem<String>(
                                value: item.value as String,
                                child: item.child,
                              ))
                          .toList(),
                      selectedLeague: model.selectedLeague ?? '',
                      backgroundColor: themeModel.appTheme == AppTheme.Light
                          ? const Color(0xfffafafa)
                          : const Color(0xff1d1d1d),
                      fontColor: themeModel.appTheme == AppTheme.Light
                          ? Colors.black
                          : Colors.white,
                      purpose: "table",
                    ),
                  ),
                  if (model.leagueTableEntries == null)
                    _buildShimmerLoading(themeModel)
                  else if (model.leagueTableEntries!.isEmpty)
                    NoContent(
                      title: 'No league table found',
                      description:
                          'There are no league table matching your query',
                    )
                  else
                    _buildLeagueTable(model.leagueTableEntries!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(ThemeProvider themeModel) {
    return Shimmer.fromColors(
      baseColor: themeModel.appTheme == AppTheme.Light
          ? Colors.grey[300]!
          : Colors.grey[700]!,
      highlightColor: themeModel.appTheme == AppTheme.Light
          ? Colors.grey[100]!
          : Colors.grey[600]!,
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLeagueTable(List<LeagueTableEntry> entries) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.3,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: entries.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    children: <Widget>[
                      tableHeader(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: tableRow(entries[index]),
                      )
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: tableRow(entries[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget tableHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width * 0.07),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: Text(
            'Club',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColorDark,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        _buildHeaderCell('MP', 0.1),
        _buildHeaderCell('W', 0.1),
        _buildHeaderCell('L', 0.1),
        _buildHeaderCell('D', 0.1),
        _buildHeaderCell('Pts.', 0.1),
        _buildHeaderCell('GF', 0.1),
        _buildHeaderCell('GA', 0.1),
        _buildHeaderCell('GD', 0.1),
      ],
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget tableRow(LeagueTableEntry entry) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.07,
          child: Text(
            '${entry.position}.',
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 16,
                child: CachedNetworkImage(
                  imageUrl: entry.teamLogo ?? '',
                  placeholder: (BuildContext context, String url) => const Icon(
                    MyFlutterApp.football,
                    size: 16,
                  ),
                ),
              ),
              Expanded(
                child: AutoSizeText(
                  entry.teamName,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        _buildTableCell(entry.matchesPlayed.toString(), 0.1),
        _buildTableCell(entry.wins.toString(), 0.1),
        _buildTableCell(entry.loses.toString(), 0.1),
        _buildTableCell(entry.draws.toString(), 0.1),
        _buildTableCell(entry.points.toString(), 0.1),
        _buildTableCell(entry.goalsFor.toString(), 0.1),
        _buildTableCell(entry.goalsAgainst.toString(), 0.1),
        _buildTableCell((entry.goalsFor - entry.goalsAgainst).toString(), 0.1),
      ],
    );
  }

  Widget _buildTableCell(String text, double width) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      child: Text(
        text,
        style: const TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }
}
