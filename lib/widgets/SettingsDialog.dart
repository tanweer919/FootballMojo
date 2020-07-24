import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../Provider/AppProvider.dart';

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  DateTime startDate, endDate;

  @override
  void initState() {
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    setState(() {
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
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
                      if (model.startDate == startDate &&
                          model.endDate == endDate) {
                        Navigator.of(context).pop();
                      } else {
                          model.startDate = startDate;
                          model.endDate = endDate;
                          Navigator.of(context).pushReplacementNamed('/league');
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
}
