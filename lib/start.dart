import 'package:flutter/material.dart';
import 'services/LocalStorage.dart';
import 'screens/FavouriteScreen1.dart';
import 'dart:async';


class Start extends StatefulWidget {
  StartState createState() => StartState();
}

class StartState extends State<Start> {
  Future checkTeam() async {
    final String teamName = await LocalStorage.getString('teamName');
    if (teamName != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => FavouriteLeague()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkTeam();
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