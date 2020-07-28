import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsmojo/Provider/AppProvider.dart';
import '../commons/BottomNavbar.dart';
import '../commons/custom_icons.dart';
import '../services/LocalStorage.dart';
import '../widgets/AllScores.dart';
import '../widgets/FavouriteScoresPast.dart';
import '../widgets/FavouriteScoresUpcoming.dart';


class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  String teamName;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    LocalStorage.getString('teamName').then((value) {
      setState(() {
        teamName = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }



  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomNavbar(),
        backgroundColor: Color(0xfff1f1f1),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              leading: Container(),
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                '$teamName',
                style: TextStyle(color: Colors.white),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Latest',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Upcoming',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0, color: Colors.white))),
            )),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            FavouriteScoresPast(),
            FavouriteScoresUpcoming()
          ],
        ));
  }
}
