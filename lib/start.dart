import 'package:flutter/material.dart';
import 'services/LocalStorage.dart';
import 'dart:async';

///Class to handle the screen that needs to shown on startup
class Start extends StatefulWidget {
  StartState createState() => StartState();
}

class StartState extends State<Start> {
  ///Function to check if favourite team is set or not
  Future checkTeam() async {

    //Variable to check if the app is opened for first time
    final String firstOpen = await LocalStorage.getString('firstOpen');

    //Get favourite team name from local storage
    final String teamName = await LocalStorage.getString('teamName');

    //If not opened for first time
    if (firstOpen != null && firstOpen == "no") {

      //If favourite team name is not set
      if(teamName == null) {
        //Navigate to the screen for selecting favourite league and team
        Navigator.of(context).pushReplacementNamed('/selectleague');
      } else {
        //Navigate to home
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      //Setup default preference during app first startup
      await LocalStorage.setString('appTheme', "light");
      await LocalStorage.setString("notificationEnabled", "yes");

      //Last topic is used to store subscribed topic in Firebase cloud messaging 
      await LocalStorage.setString('lastTopic', null);
      await LocalStorage.setString('firstOpen', 'no');

      //During first startup navigate to introduction screen
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
    //Just show CircularProgressIndicator while loading user preference
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}