import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportsmojo/Provider/MatchStatViewModel.dart';
import 'package:sportsmojo/commons/custom_icons.dart';
import '../models/Score.dart';
import '../widgets/Stats.dart';
import '../services/GetItLocator.dart';
import 'package:provider/provider.dart';

class MatchStatScreen extends StatefulWidget {
  final Score score;
  MatchStatScreen({this.score});

  @override
  _MatchStatScreenState createState() => _MatchStatScreenState();
}

class _MatchStatScreenState extends State<MatchStatScreen> with TickerProviderStateMixin {
  final MatchStatViewModel _matchStatViewModel = locator<MatchStatViewModel>();
  Animation<double> animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation =
    Tween<double>(begin: 20.0, end: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '${widget.score.competition} - ${DateFormat('E, d MMMM, hh:mm aaa').format(widget.score.date_time)}',
                        style: TextStyle(
                            fontSize: 12, color: Color(0X8A000000)),
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 20.0,
                          child: Text(
                            (widget.score.minuteElapsed != null &&
                                widget.score.minuteElapsed != 90 &&
                                widget.score.minuteElapsed != 120)
                                ? "${widget.score.minuteElapsed}'"
                                : "${widget.score.status}",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        if (widget.score.minuteElapsed != null &&
                            widget.score.minuteElapsed != 90 &&
                            widget.score.minuteElapsed != 120)
                          Container(
                            width: animation.value,
                            height: 2.0,
                            color: Colors.red,
                          )
                      ],
                    )
                  ],
                ),
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
                                  imageUrl: widget.score.homeTeamLogo,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Icon(MyFlutterApp.football))),
                        ),
                        FittedBox(child: Text(widget.score.homeTeam)),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (widget.score.minuteElapsed != null)
                              ? Text(
                                  '${widget.score.homeScore} - ${widget.score.awayScore}',
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
                                  imageUrl: widget.score.awayTeamLogo,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Icon(MyFlutterApp.football))),
                        ),
                        FittedBox(child: Text(widget.score.awayTeam))
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
                Stats(score: widget.score,)
              ],
            ),
          ),
        ),
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
