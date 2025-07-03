import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../Provider/AppProvider.dart';
import '../commons/CustomRaisedButton.dart';

class SettingsDialog extends StatefulWidget {
  final Color borderColor;
  const SettingsDialog({required this.borderColor});
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);

    final firstDate =
        getFirstAndLastDate(appProvider.leagueWiseScores)["firstDate"]
            as DateTime;
    final lastDate =
        getFirstAndLastDate(appProvider.leagueWiseScores)["lastDate"]
            as DateTime;

    setState(() {
      startDate = dayDifference(
                  date_time1: firstDate,
                  date_time2: appProvider.startDate ?? now) <
              0
          ? appProvider.startDate ?? now
          : firstDate;
      endDate = dayDifference(
                  date_time1: lastDate,
                  date_time2: appProvider.endDate ?? now) >
              0
          ? appProvider.endDate ?? now
          : lastDate;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, model, child) => Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: getFirstAndLastDate(
                            model.leagueWiseScores)["firstDate"] as DateTime,
                        lastDate: getFirstAndLastDate(
                            model.leagueWiseScores)["lastDate"] as DateTime);
                    if (pickedDate != null) {
                      setState(() {
                        startDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: widget.borderColor),
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
                    final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: getFirstAndLastDate(
                            model.leagueWiseScores)["firstDate"] as DateTime,
                        lastDate: getFirstAndLastDate(
                            model.leagueWiseScores)["lastDate"] as DateTime);
                    if (pickedDate != null) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: widget.borderColor),
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
                CustomRaisedButton(
                  height: 40,
                  minWidth: 100,
                  label: 'Save',
                  inProgress: false,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
