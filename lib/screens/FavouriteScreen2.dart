import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sportsmojo/Provider/AppProvider.dart';
import 'package:sportsmojo/commons/custom_icons.dart';
import 'package:sportsmojo/models/User.dart';
import '../models/Team.dart';
import '../services/TeamService.dart';
import '../services/LocalStorage.dart';
import '../services/GetItLocator.dart';
import '../services/FirestoreService.dart';
import '../services/FirebaseMessagingService.dart';
import '../Provider/ThemeProvider.dart';

class FavouriteTeam extends StatefulWidget {
  final int leagueId;
  final String leagueName;
  FavouriteTeam({this.leagueId, this.leagueName});

  @override
  _FavouriteTeamState createState() => _FavouriteTeamState();
}

class _FavouriteTeamState extends State<FavouriteTeam> {
  List<Team> teamList;
  List<Team> originalTeamList;
  Future<List<Team>> futureTeamList;
  final TextEditingController _controller = new TextEditingController();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseMessagingService _fcmService =
      locator<FirebaseMessagingService>();

  @override
  void initState() {
    TeamService _teamService = locator<TeamService>();
    super.initState();
    setState(() {
      futureTeamList = _teamService.fetchTeams(id: widget.leagueId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Consumer<ThemeProvider>(
        builder: (context, themeModel, child) => SafeArea(
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
                                child: Text(
                                  'Loading teams',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SpinKitFadingCube(
                                color: Colors.white,
                              )
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
                                padding:
                                    EdgeInsets.only(top: 30.0, bottom: 10.0),
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
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          vertical: 10.0),
                                      child: Material(
                                        elevation: 12,
                                        child: Container(
                                          child: TextField(
                                            controller: _controller,
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            decoration: InputDecoration(
                                              hintText: 'Search teams',
                                              hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                                              suffixIcon: Icon(
                                                Icons.search,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
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
                                                        .contains(_controller
                                                            .text
                                                            .toLowerCase()))
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        'Select your favourite club',
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    teamList.length > 0
                                        ? teamListView(appProvider: appProvider, themeModel: themeModel)
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
            ));
  }

  Widget teamListView({AppProvider appProvider, ThemeProvider themeModel}) {
    return Column(
        children: teamList
            .map<Widget>((team) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      await handleTap(team: team, appProvider: appProvider);
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
                              child: Container(
                                child: CachedNetworkImage(
                                  imageUrl: team.logo,
                                  fit: BoxFit.contain,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Icon(MyFlutterApp.football),
                                ),
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

  Future<void> handleTap({Team team, AppProvider appProvider}) async {
    {
      LocalStorage.setString('teamName', team.name);
      LocalStorage.setString('teamId', '${team.id}');
      LocalStorage.setString('teamLogo', team.logo);
      LocalStorage.setString('leagueName', '${widget.leagueName}');
      LocalStorage.setString('leagueId', '${widget.leagueId}');
      appProvider.selectedLeague = widget.leagueName;
      appProvider.leagueWiseScores = null;
      appProvider.favouriteTeamScores = null;
      appProvider.newsList = null;
      appProvider.favouriteNewsList = null;
      appProvider.leagueTableEntries = null;
      appProvider.navbarIndex = 0;
      if (appProvider.currentUser != null) {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.chasingDots
          ..loadingStyle = EasyLoadingStyle.custom
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Theme.of(context).primaryColor
          ..indicatorColor = Colors.white
          ..maskColor = Colors.blue.withOpacity(0.5)
          ..progressColor = Theme.of(context).primaryColor
          ..textColor = Colors.white;
        EasyLoading.show(status: 'Syncing data');
        final User user = appProvider.currentUser;
        final Map<String, dynamic> data = {
          'name': user.name,
          'email': user.email,
          'teamName': team.name,
          'teamId': '${team.id}',
          'teamLogo': team.logo,
          'leagueName': '${widget.leagueName}',
          'leagueId': '${widget.leagueId}'
        };
        await _firestoreService.setData(userId: user.uid, data: data);
        EasyLoading.dismiss();
      }
      await _fcmService.subscribeToTopic(topic: team.name.replaceAll(' ', ''));
      Navigator.of(context).pushReplacementNamed('/home', arguments: {
        'favouriteTeamMessage': {
          'title': 'Success',
          'content': '${team.name} added as your favourite team'
        }
      });
    }
    ;
  }
}
