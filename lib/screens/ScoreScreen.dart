import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsmojo/Provider/AppProvider.dart';
import '../commons/BottomNavbar.dart';
import '../commons/custom_icons.dart';
import '../services/LocalStorage.dart';
import '../widgets/AllScores.dart';
import '../widgets/FavouriteScores.dart';
import '../services/GetItLocator.dart';
import '../Provider/AllScoresViewModel.dart';

class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  String teamName;
  String leagueName;
  AllScoresViewModel _allScoresViewModel;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    LocalStorage.getString('teamName').then((value) {
      setState(() {
        teamName = value;
      });
    });
    LocalStorage.getString('leagueName').then((value) {
      setState(() {
        _allScoresViewModel = locator<AllScoresViewModel>(param1: value);
      });
    });
  }



  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => _allScoresViewModel,
      child: Scaffold(
          bottomNavigationBar: BottomNavbar(),
          backgroundColor: Color(0xfff1f1f1),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: AppBar(
                leading: Container(),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  'Scores',
                  style: TextStyle(color: Colors.white),
                ),
                bottom: TabBar(
                    controller: _tabController,
                    tabs: <Widget>[
                      Consumer<AllScoresViewModel>(
                        builder: (context, model, child) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            (model != null) ? '${model.selectedLeague}' : 'All',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '$teamName',
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
              AllScores(),
              FavouriteScores()
            ],
          )),
    );
  }

  Widget scorers() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 2.0),
                      child: Text(
                        'Benzema 4',
                        style:
                            TextStyle(color: Color(0xff808080), fontSize: 12),
                      ),
                    ),
                    Icon(MyFlutterApp.football, size: 14),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 2.0),
                      child: Text(
                        'Ramos 35',
                        style:
                            TextStyle(color: Color(0xff808080), fontSize: 12),
                      ),
                    ),
                    Icon(MyFlutterApp.football, size: 14),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 2.0),
                      child: Text(
                        'Modric 48',
                        style:
                            TextStyle(color: Color(0xff808080), fontSize: 12),
                      ),
                    ),
                    Icon(MyFlutterApp.football, size: 14),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 2.0),
                      child: Text(
                        'Vinicius 74\'',
                        style:
                            TextStyle(color: Color(0xff808080), fontSize: 12),
                      ),
                    ),
                    Icon(MyFlutterApp.football, size: 14),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 2.0),
                      child: Text(
                        'Mariano 81',
                        style:
                            TextStyle(color: Color(0xff808080), fontSize: 12),
                      ),
                    ),
                    Icon(MyFlutterApp.football, size: 14),
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(MyFlutterApp.football, size: 14),
                    Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: Text(
                          'Messi 12',
                          style:
                              TextStyle(color: Color(0xff808080), fontSize: 12),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(MyFlutterApp.football, size: 14),
                    Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: Text(
                          'Messi 15',
                          style:
                              TextStyle(color: Color(0xff808080), fontSize: 12),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(MyFlutterApp.football, size: 14),
                    Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: Text(
                          'Suarez 43',
                          style:
                              TextStyle(color: Color(0xff808080), fontSize: 12),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(MyFlutterApp.football, size: 14),
                    Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: Text(
                          'Vidal 67',
                          style:
                              TextStyle(color: Color(0xff808080), fontSize: 12),
                        )),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
