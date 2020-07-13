import 'package:flutter/material.dart';
import '../widgets/LeagueDropdown.dart';
import '../constants.dart';
class SettingsDialog extends StatefulWidget{

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  List<DropdownMenuItem> leaguesIems = leagues.entries
      .map<DropdownMenuItem<String>>((entry) => DropdownMenuItem<String>(
    value: entry.key,
    child: Text(entry.key),
  ))
      .toList();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LeagueDropdown(
          items: leaguesIems,
        )
      ],
    );
  }
}