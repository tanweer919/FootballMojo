import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/LeagueDropdown.dart';
import '../constants.dart';
import '../Provider/AppProvider.dart';
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
    return Consumer<AppProvider>(
      builder: (context, model, child) => Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Select League:', style: TextStyle(fontSize: 18),),
              LeagueDropdown(
                items: leaguesIems,
              ),
            ],
          ),
          Divider(thickness: 0.7),
          InkWell(
            onTap: () {
              showDatePicker(context: context, initialDate: model.startDate, firstDate: model.startDate, lastDate: model.endDate);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('${DateFormat('d-M-y').format(model.startDate)}'),
                Icon(Icons.date_range)
              ],
            ),
          ),
          Divider(thickness: 0.7,),
          InkWell(
            onTap: () {
              showDatePicker(context: context, initialDate: model.startDate, firstDate: model.startDate, lastDate: model.endDate);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('${DateFormat('d-M-y').format(model.endDate)}'),
                Icon(Icons.date_range)
              ],
            ),
          )
        ],
      ),
    );
  }
}