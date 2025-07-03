import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../commons/BottomNavbar.dart';
import '../widgets/LeagueTableWiget.dart';
import '../widgets/AllScores.dart';
import '../widgets/TopScorer.dart';

class LeagueTableScreen extends StatefulWidget {
  const LeagueTableScreen({Key? key}) : super(key: key);
  @override
  _LeagueTableScreenState createState() => _LeagueTableScreenState();
}

class _LeagueTableScreenState extends State<LeagueTableScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            appProvider.selectedLeague ?? 'League Table',
            style: const TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Table',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Scores',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Top Scorers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: Colors.white),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          LeagueTableWidget(),
          AllScores(),
          TopScorers(),
        ],
      ),
    );
  }
}
