import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';

class LeagueDropdown extends StatefulWidget {
  final List<DropdownMenuItem> items;
  Function(String) onChange;
  String selectedLeague;
  LeagueDropdown({this.items, this.onChange, this.selectedLeague});
  @override
  _LeagueDropdownState createState() => _LeagueDropdownState();
}

class _LeagueDropdownState extends State<LeagueDropdown> {
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (context, model, child) => Theme(
              data: Theme.of(context)
                  .copyWith(canvasColor: Theme.of(context).primaryColor),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1),
                  color: Theme.of(context).primaryColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      iconEnabledColor: Colors.white,
                      value: widget.selectedLeague,
                      items: widget.items,
                      style: TextStyle(color: Colors.white, fontSize: 11),
                      onChanged: (widget.onChange != null)
                          ? widget.onChange
                          : (String value) async {
                              model.selectedLeague = value;
                              model.leagueTableEntries = null;
                              await model.loadLeagueTable(
                                  leagueName: value);
                            },
                    ),
                  ),
                ),
              ),
            ));
  }
}
