import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../commons/BottomNavbar.dart';
import '../commons/custom_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[UpcomingMatchesSection(), NewsSection()],
          ),
        ),
      ),
    ));
  }

  Widget UpcomingMatchesSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Upcoming/Live Matches',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('La Liga'),
                        Spacer(),
                        Container(
                          width: 20.0,
                          child: Text(
                            "73'",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                padding: const EdgeInsets.only(bottom: 8.0),
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
                    )
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  Widget NewsSection() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Latest News',
            style: TextStyle(fontSize: 14),
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 80,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://www.thesun.co.uk/wp-content/uploads/2018/07/NINTCHDBPICT000485853573.jpg?strip=all&w=200',
                        ),
                      ),
                      Container(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical : 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  'Yaya Toure edges Man City Closer to PL title',
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Bleacher Report',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    '1hr',
                                    style: TextStyle(
                                        fontSize: 11, color: Color(0xff808080)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
