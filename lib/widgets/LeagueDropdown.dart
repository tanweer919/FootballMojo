import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AllScoresViewModel.dart';
class LeagueDropdown extends StatefulWidget {
  final List<DropdownMenuItem> items;
  LeagueDropdown({this.items});
  @override
  _LeagueDropdownState createState() => _LeagueDropdownState();
}

class _LeagueDropdownState extends State<LeagueDropdown> {
  Widget build(BuildContext context) {
    return Consumer<AllScoresViewModel>(
      builder: (context, model, child) => Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme.of(context).primaryColor),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            color:Theme.of(context).primaryColor,
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                iconEnabledColor: Colors.white,
                value: model.selectedLeague,
                items: widget.items,
                style: TextStyle(color: Colors.white, fontSize: 11),
                onChanged: (String value) {
                  model.selectedLeague = value;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}