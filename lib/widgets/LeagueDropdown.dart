import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';

class LeagueDropdown extends StatefulWidget {
  final List<DropdownMenuItem> items;
  String selectedLeague;
  Color backgroundColor;
  Color fontColor;
  String purpose;
  LeagueDropdown({this.items, this.selectedLeague, this.purpose, this.backgroundColor, this.fontColor});
  @override
  _LeagueDropdownState createState() => _LeagueDropdownState();
}

class _LeagueDropdownState extends State<LeagueDropdown> {
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (context, model, child) => Theme(
              data: Theme.of(context)
                  .copyWith(canvasColor: widget.backgroundColor),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      iconEnabledColor: widget.fontColor,
                      value: widget.selectedLeague,
                      items: widget.items,
                      style: TextStyle(color: widget.fontColor, fontSize: 11, fontWeight: FontWeight.w500),
                      onChanged: (String value) async {
                              model.selectedLeague = value;
                              model.leagueTableEntries = null;
                              model.leagueWiseScores = null;
                              if(widget.purpose == "table") {
                                await model.loadLeagueTable(
                                    leagueName: value);
                                await model.loadLeagueWiseScores(leagueName: value);
                              }
                              if(widget.purpose == "score") {
                                await model.loadLeagueWiseScores(leagueName: value);
                                await model.loadLeagueTable(
                                    leagueName: value);
                                Navigator.of(context).pushReplacementNamed('/league');
                              }
                            },
                    ),
                  ),
                ),
              ),
            ));
  }
}
