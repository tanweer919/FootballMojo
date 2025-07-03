import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';

class LeagueDropdown extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final String selectedLeague;
  final Color backgroundColor;
  final Color fontColor;
  final String purpose;
  LeagueDropdown({
    required this.items,
    required this.selectedLeague,
    required this.purpose,
    required this.backgroundColor,
    required this.fontColor,
  });

  @override
  _LeagueDropdownState createState() => _LeagueDropdownState();
}

class _LeagueDropdownState extends State<LeagueDropdown> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
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
                      style: TextStyle(
                          color: widget.fontColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500),
                      onChanged: (String? value) async {
                        if (value != null && model.selectedLeague != value) {
                          model.selectedLeague = value;
                          model.leagueTableEntries.clear();
                          model.leagueWiseScores.clear();
                          model.topScorers.clear();
                          if (widget.purpose == "topscorer") {
                            await model.loadTopScorers(leagueName: value);
                          }
                          if (widget.purpose == "table") {
                            await model.loadLeagueTable(leagueName: value);
                            await model.loadLeagueWiseScores(leagueName: value);
                          }
                          if (widget.purpose == "score") {
                            await model.loadLeagueTable(leagueName: value);
                            Navigator.of(context)
                                .pushReplacementNamed('/league');
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ));
  }
}
