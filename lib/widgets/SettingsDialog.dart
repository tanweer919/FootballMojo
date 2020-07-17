import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/LeagueDropdown.dart';
import '../constants.dart';
import '../Provider/AppProvider.dart';

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  String dropdownValue;
  DateTime startDate, endDate;
  List<DropdownMenuItem> leaguesIems = leagues.entries
      .map<DropdownMenuItem<String>>((entry) => DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.key),
          ))
      .toList();

  @override
  void initState() {
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    setState(() {
      dropdownValue = appProvider.selectedLeague;
      startDate = dayDifference(
                  date_time1: getFirstAndLastDate(appProvider.leagueWiseScores)["firstDate"],
                  date_time2: appProvider.startDate) <
              0
          ? appProvider.startDate
          : getFirstAndLastDate(appProvider.leagueWiseScores)["firstDate"];
      endDate = dayDifference(
                  date_time1: getFirstAndLastDate(appProvider.leagueWiseScores)["lastDate"],
                  date_time2: appProvider.endDate) >
              0
          ? appProvider.endDate
          : getFirstAndLastDate(appProvider.leagueWiseScores)["lastDate"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, model, child) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Select League:',
                  style: TextStyle(fontSize: 18),
                ),
                LeagueDropdown(
                  items: leaguesIems,
                  onChange: onDropdownChange,
                  selectedLeague: dropdownValue,
                ),
              ],
            ),
          ),
          Divider(thickness: 0.7),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final DateTime date = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: getFirstAndLastDate(model.leagueWiseScores)["firstDate"],
                        lastDate: getFirstAndLastDate(model.leagueWiseScores)["lastDate"]);
                    if (date != null) {
                      setState(() {
                        startDate = date;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(Icons.date_range),
                          ),
                          Text(
                            '${DateFormat('d-M-y').format(startDate)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  '-',
                  style: TextStyle(fontSize: 30),
                ),
                InkWell(
                  onTap: () async {
                    final DateTime date = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: getFirstAndLastDate(model.leagueWiseScores)["firstDate"],
                        lastDate: getFirstAndLastDate(model.leagueWiseScores)["lastDate"]);
                    if (date != null) {
                      setState(() {
                        endDate = date;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(Icons.date_range),
                          ),
                          Text(
                            '${DateFormat('d-M-y').format(endDate)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(thickness: 0.7),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ButtonTheme(
                  height: 40,
                  minWidth: 100,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (model.selectedLeague == dropdownValue &&
                          model.startDate == startDate &&
                          model.endDate == endDate) {
                        Navigator.of(context).pop();
                      } else {
                        if (model.selectedLeague != dropdownValue ) {
                          model.selectedLeague = dropdownValue;
                          model.startDate = startDate;
                          model.endDate = endDate;
                          model.leagueWiseScores = null;
                          await model.loadLeagueWiseScores(
                              leagueName: dropdownValue);
                          Navigator.of(context).pushReplacementNamed('/score');
                        }
                        else {
                          model.startDate = startDate;
                          model.endDate = endDate;
                          Navigator.of(context).pushReplacementNamed('/score');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onDropdownChange(String value) {
    setState(() {
      dropdownValue = value;
    });
  }
}
