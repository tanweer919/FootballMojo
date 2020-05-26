import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:sportsmojo/commons/custom_icons.dart';
import '../commons/BottomNavbar.dart';
import '../constants.dart';
import '../models/Team.dart';
import '../helper/TeamService.dart';
import '../helper/LocalStorage.dart';

class FavouriteTeam extends StatefulWidget {
  final int leagueId;
  FavouriteTeam({this.leagueId});

  @override
  _FavouriteTeamState createState() => _FavouriteTeamState();
}

class _FavouriteTeamState extends State<FavouriteTeam> {
  List<Team> teamList;
  List<Team> originalTeamList;
  Future<List<Team>> futureTeamList;
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      futureTeamList = TeamService(id: widget.leagueId).fetchTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        body: FutureBuilder<List<Team>>(
            future: futureTeamList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Theme.of(context).primaryColor,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text('Loading teams', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white,),),
                      ),
                      SpinKitFadingCube(color: Colors.white,)
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                originalTeamList = snapshot.data;
                teamList = originalTeamList
                    .where((team) => team.name
                    .toLowerCase()
                    .contains(_controller.text.toLowerCase()))
                    .toList();
                return Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
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
                                  child: TextField(
                                    controller: _controller,
                                    cursorColor: Theme.of(context).primaryColor,
                                    decoration: InputDecoration(
                                      hintText: 'Search teams',
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
                                teamList = originalTeamList
                                    .where((team) => team.name
                                        .toLowerCase()
                                        .contains(_controller.text.toLowerCase()))
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
                                'Select your favourite club',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            teamList.length > 0
                                ? teamListView()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'No team matched your query',
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
                );
              }
            }),
      ),
    );
  }

  Widget teamListView() {
    return Column(
        children: teamList
            .map<Widget>((team) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      LocalStorage.setString('teamName', team.name);
                      LocalStorage.setString('teamId', '${team.id}');
                      Navigator.of(context)
                          .pushReplacementNamed('/home', arguments: {
                        'favouriteTeamMessage': {
                          'title': 'Success',
                          'content': '${team.name} added as your favourite team'
                        }
                      });
                    },
                    child: Container(
                      height: 40,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              child: CachedNetworkImage(
                                imageUrl: team.logo,
                                fit: BoxFit.contain,
                                placeholder:
                                    (BuildContext context, String url) =>
                                        Icon(MyFlutterApp.football),
                              ),
                            ),
                          ),
                          Text(
                            team.name,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
            .toList());
  }
}
