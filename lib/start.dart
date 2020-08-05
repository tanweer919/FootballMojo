import 'package:flutter/material.dart';
import 'services/LocalStorage.dart';
import 'dart:async';


class Start extends StatefulWidget {
  StartState createState() => StartState();
}

class StartState extends State<Start> {
  Future checkTeam() async {
    final String firstOpen = await LocalStorage.getString('firstOpen');
    final String teamName = await LocalStorage.getString('teamName');
    if (firstOpen != null && firstOpen == "no") {
      if(teamName == null) {
        Navigator.of(context).pushReplacementNamed('/selectleague');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      await LocalStorage.setString('appTheme', "light");
      await LocalStorage.setString("notificationEnabled", "yes");
      await LocalStorage.setString('lastTopic', null);
      await LocalStorage.setString('firstOpen', 'no');
      Navigator.of(context).pushReplacementNamed('/introduction');
    }
  }

  @override
  void initState() {
    super.initState();
    checkTeam();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}