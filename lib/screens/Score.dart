import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../commons/BottomNavbar.dart';
import '../commons/custom_icons.dart';

class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _animationController;
  List<bool> _cardExpanded = List<bool>.generate(8, (index) => false);
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween<double>(begin: 20.0, end: 0.0).animate(_animationController)
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 30.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 8,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        child: InkWell(
                          onTap: () {
                            List<bool> newList =
                            List<bool>.generate(8, (index) => false);
                            newList[index] = !_cardExpanded[index];
                            setState(() {
                              _cardExpanded = newList;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('La Liga'),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 20.0,
                                          child: Text(
                                            "73'",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        Container(
                                          width: animation.value,
                                          height: 2.0,
                                          color: Colors.red,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                            child: Container(
                                                height: 60,
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                    'https://icons.iconarchive.com/icons/giannis-zographos/spanish-football-club/256/Real-Madrid-icon.png')),
                                          ),
                                          Text('Real Madrid')
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '5 - 4',
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                            child: Container(
                                                height: 60,
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                    'https://icons.iconarchive.com/icons/giannis-zographos/spanish-football-club/256/FC-Barcelona-icon.png')),
                                          ),
                                          Text('FC Barcelona')
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                if (_cardExpanded[index])
                                  Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(right: 2.0),
                                                    child: Text(
                                                      'Benzema 4',
                                                      style: TextStyle(
                                                          color: Color(0xff808080),
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(right: 2.0),
                                                    child: Text(
                                                      'Ramos 35',
                                                      style: TextStyle(
                                                          color: Color(0xff808080),
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(right: 2.0),
                                                    child: Text(
                                                      'Modric 48',
                                                      style: TextStyle(
                                                          color: Color(0xff808080),
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(right: 2.0),
                                                    child: Text(
                                                      'Vinicius 74\'',
                                                      style: TextStyle(
                                                          color: Color(0xff808080),
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(right: 2.0),
                                                    child: Text(
                                                      'Mariano 81',
                                                      style: TextStyle(
                                                          color: Color(0xff808080),
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.0),
                                                      child: Text(
                                                        'Messi 12',
                                                        style: TextStyle(
                                                            color:
                                                            Color(0xff808080),
                                                            fontSize: 12),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.0),
                                                      child: Text(
                                                        'Messi 15',
                                                        style: TextStyle(
                                                            color:
                                                            Color(0xff808080),
                                                            fontSize: 12),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.0),
                                                      child: Text(
                                                        'Suarez 43',
                                                        style: TextStyle(
                                                            color:
                                                            Color(0xff808080),
                                                            fontSize: 12),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Icon(MyFlutterApp.football,
                                                      size: 14),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.0),
                                                      child: Text(
                                                        'Vidal 67',
                                                        style: TextStyle(
                                                            color:
                                                            Color(0xff808080),
                                                            fontSize: 12),
                                                      )),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ));
  }
}
