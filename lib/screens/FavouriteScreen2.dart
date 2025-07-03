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
  const FavouriteTeam(
      {Key? key, required this.leagueId, required this.leagueName})
      : super(key: key);

  @override
  _FavouriteTeamState createState() => _FavouriteTeamState();
}

class _FavouriteTeamState extends State<FavouriteTeam> {
  List<Team> teamList = [];
  List<Team> originalTeamList = [];
  Future<List<Team>>? futureTeamList;
  final TextEditingController _controller = TextEditingController();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseMessagingService _fcmService =
      locator<FirebaseMessagingService>();
  bool showTutorial = false;

  @override
  void initState() {
    super.initState();
    final TeamService _teamService = locator<TeamService>();
    setState(() {
      futureTeamList =
          _teamService.fetchTeams(id: widget.leagueId).then((teams) {
        if (teams != null) {
          setState(() {
            teamList = teams;
            originalTeamList = teams;
          });
        }
        return teams ?? [];
      });
    });
    _loadTutorialState();
  }

  Future<void> _loadTutorialState() async {
    final value = await LocalStorage.getString('showTutorial');
    if (value == "yes") {
      setState(() {
        showTutorial = true;
      });
      await LocalStorage.setString('showTutorial', 'no');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeModel, child) => Scaffold(
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
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                          vertical: 10.0),
                      child: Material(
                        elevation: 12,
                        child: Container(
                          child: TextField(
                            controller: _controller,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              hintText: 'Search teams',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                              suffixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            style: TextStyle(fontSize: 18),
                            onChanged: (String val) {
                              setState(() {
                                teamList = originalTeamList
                                    .where((team) => team.name
                                        .toLowerCase()
                                        .contains(
                                            _controller.text.toLowerCase()))
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
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Select your favourite club',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    teamList.length > 0
                        ? teamListView(themeModel: themeModel)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No team matched your query',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColorDark),
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
    );
  }

  Widget teamListView({required ThemeProvider themeModel}) {
    return Column(
      children: teamList
          .map<Widget>((team) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    await handleTap(team: team);
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
                            child: CachedNetworkImage(
                              imageUrl: team.logo ?? '',
                              fit: BoxFit.contain,
                              placeholder: (BuildContext context, String url) =>
                                  const Icon(MyFlutterApp.football),
                            ),
                          ),
                        ),
                        Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Future<void> handleTap({required Team team}) async {
    await _handleTeamSelection(team);
  }

  Future<void> _handleTeamSelection(Team team) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final user = appProvider.currentUser;
    if (user == null) {
      await _handleAnonymousTeamSelection(team);
      return;
    }

    await LocalStorage.setString('teamId', team.id.toString());
    await LocalStorage.setString('teamName', team.name);
    await LocalStorage.setString('teamLogo', team.logo ?? '');
    await LocalStorage.setString('leagueId', widget.leagueId.toString());
    await LocalStorage.setString('leagueName', widget.leagueName);

    final updatedUser = User(
      uid: user.uid,
      name: user.name,
      email: user.email,
      profilePic: user.profilePic,
    );

    await _firestoreService.setData(
      userId: user.uid,
      data: {
        'name': user.name,
        'email': user.email,
        'profilePic': user.profilePic,
        'teamId': team.id.toString(),
        'teamName': team.name,
        'teamLogo': team.logo ?? '',
        'leagueId': widget.leagueId.toString(),
        'leagueName': widget.leagueName,
      },
    );
    appProvider.currentUser = updatedUser;

    final topic = team.name.replaceAll(' ', '');
    if (topic.isNotEmpty) {
      await _fcmService.subscribeToTopic(topic: topic);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home', arguments: {
      'teamName': team.name,
      'teamId': team.id.toString(),
      'teamLogo': team.logo ?? '',
      'leagueName': widget.leagueName,
      'leagueId': widget.leagueId.toString(),
    });
  }

  Future<void> _handleAnonymousTeamSelection(Team team) async {
    await LocalStorage.setString('teamId', team.id.toString());
    await LocalStorage.setString('teamName', team.name);
    await LocalStorage.setString('teamLogo', team.logo ?? '');
    await LocalStorage.setString('leagueId', widget.leagueId.toString());
    await LocalStorage.setString('leagueName', widget.leagueName);

    final topic = team.name.replaceAll(' ', '');
    if (topic.isNotEmpty) {
      await _fcmService.subscribeToTopic(topic: topic);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home', arguments: {
      'teamName': team.name,
      'teamId': team.id.toString(),
      'teamLogo': team.logo ?? '',
      'leagueName': widget.leagueName,
      'leagueId': widget.leagueId.toString(),
    });
  }
}
