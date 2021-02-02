import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../Provider/ThemeProvider.dart';
import '../commons/custom_icons.dart';

class FavouriteLeague extends StatefulWidget {
  @override
  _FavouriteLeagueState createState() => _FavouriteLeagueState();
}

class _FavouriteLeagueState extends State<FavouriteLeague> {
  TextEditingController _controller = TextEditingController();
  List<MapEntry<String, dynamic>> leagueList;
  @override
  void initState() {
    super.initState();
    leagueList = leagues.entries.toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeModel, child) => SafeArea(
              child: Scaffold(
                body: Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Select your favourite team',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.1,
                                  vertical: 10.0),
                              child: Material(
                                elevation: 12,
                                child: Container(
                                  child: TextFormField(
                                    cursorColor: Theme.of(context).primaryColor,
                                    decoration: InputDecoration(
                                      hintText: 'Search leagues',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).primaryColorDark
                                      ),
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                    ),
                                    style: TextStyle(fontSize: 18),
                                    onChanged: (String val) {
                                      setState(() {
                                        leagueList = leagues.entries
                                            .where((league) => league.key
                                                .toLowerCase()
                                                .contains(val.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Select league',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            leagueList.length > 0
                                ? Column(
                                    children: showLeagues(context: context, themeModel: themeModel),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'No league matched your query',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                      )
                                    ],
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  List<Widget> showLeagues({BuildContext context, ThemeProvider themeModel}) {
    return leagueList
        .map((league) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/selectteam', arguments: {
                    'leagueId': league.value["id"],
                    'leagueName': league.key
                  });
                },
                child: Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: themeModel.appTheme == AppTheme.Light ? Colors.transparent : Colors.white,
                          child: CachedNetworkImage(
                            imageUrl: league.value["logo"],
                            fit: BoxFit.contain,
                            placeholder:
                                (BuildContext context, String url) =>
                                Icon(MyFlutterApp.football),
                          ),
                        ),
                      ),
                      Text(
                        league.key,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }
}
