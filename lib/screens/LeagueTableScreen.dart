import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../commons/BottomNavbar.dart';
import '../widgets/LeagueTableWiget.dart';
import '../widgets/AllScores.dart';

class LeagueTableScreen extends StatefulWidget {
  @override
  _LeagueTableScreenState createState() => _LeagueTableScreenState();
}

class _LeagueTableScreenState extends State<LeagueTableScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomNavbar(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              leading: Container(),
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                'League',
                style: TextStyle(color: Colors.white),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Matchday',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Table',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Top Scorer',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
            AllScores(),
            LeagueTableWidget(),
            Container()
          ],
        ));
  }
}
