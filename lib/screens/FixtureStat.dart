import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sportsmojo/commons/custom_icons.dart';
import '../models/Score.dart';

class FixtureStat extends StatelessWidget {
  final Score score;
  FixtureStat({this.score});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                              height: 60,
                              child: CachedNetworkImage(
                                  imageUrl: score.homeTeamLogo,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Icon(MyFlutterApp.football))),
                        ),
                        FittedBox(child: Text(score.homeTeam)),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (score.minuteElapsed != null)
                              ? Text(
                                  '${score.homeScore} - ${score.awayScore}',
                                  style: TextStyle(fontSize: 30),
                                )
                              : Text(
                                  'VS',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0XAA000000)),
                                ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                              height: 60,
                              child: CachedNetworkImage(
                                  imageUrl: score.awayTeamLogo,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Icon(MyFlutterApp.football))),
                        ),
                        FittedBox(child: Text(score.awayTeam))
                      ],
                    )
                  ],
                ),
                Divider(
                  thickness: 0.7,
                ),
                scorers(),
                Divider(
                  thickness: 0.7,
                ),
                stats()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stats() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 25,
                  child: CachedNetworkImage(
                      imageUrl: score.homeTeamLogo,
                      placeholder: (BuildContext context, String url) =>
                          Icon(MyFlutterApp.football))),
              Text('Team Stats'),
              Container(
                  height: 25,
                  child: CachedNetworkImage(
                      imageUrl: score.awayTeamLogo,
                      placeholder: (BuildContext context, String url) =>
                          Icon(MyFlutterApp.football)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('6', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Shots', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('8', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('1', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Shots on target', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('4', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('43%', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Possession', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('57%', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('12', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Fouls', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('8', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('4', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Yellow Cards', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('3', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('0', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Red Cards', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('0', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('3', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Offsides', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('1', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('3', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('Corners', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                Text('2', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget scorers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Messi 12'(P)", style: TextStyle(fontSize: 14, color: Color(0XAA000000)), textAlign: TextAlign.left,),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Pique 26'", style: TextStyle(fontSize: 14, color: Color(0XAA000000)), textAlign: TextAlign.left,),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Suarez 42'", style: TextStyle(fontSize: 14, color: Color(0XAA000000)), textAlign: TextAlign.left,),
            ),
          ],
        ),
        Container(
          height: 15,
          child: Icon(MyFlutterApp.football, color: Color(0XAA000000),),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Ramos 22'", style: TextStyle(fontSize: 14, color: Color(0XAA000000)), textAlign: TextAlign.right,),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Hazard 26'", style: TextStyle(fontSize: 14, color: Color(0XAA000000)), textAlign: TextAlign.right,),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Ramos 44'(P)", style: TextStyle(fontSize: 14, color: Color(0XAA000000)), textAlign: TextAlign.right,),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Vinicius 84'", style: TextStyle(fontSize: 14, color: Color(0XAA000000)), textAlign: TextAlign.right,),
            ),
          ],
        )
      ],
    );
  }
}
