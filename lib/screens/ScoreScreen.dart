import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsmojo/Provider/AppProvider.dart';
import '../commons/BottomNavbar.dart';
import '../services/LocalStorage.dart';
import '../widgets/FavouriteScoresPast.dart';
import '../widgets/FavouriteScoresUpcoming.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String teamName = '';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    LocalStorage.getString('teamName').then((value) {
      setState(() {
        teamName = value ?? '';
      });
    });
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
                teamName.isNotEmpty ? teamName : 'Scores',
                style: const TextStyle(color: Colors.white),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Latest',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
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
                  indicator: const UnderlineTabIndicator(
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
