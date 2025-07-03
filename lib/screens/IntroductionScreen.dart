import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/FirebaseService.dart';
import '../services/FirestoreService.dart';
import '../services/LocalStorage.dart';
import '../services/GetItLocator.dart';
import '../Provider/AppProvider.dart';
import '../models/User.dart';
import '../services/FirebaseMessagingService.dart';
import '../models/Score.dart';
import '../models/News.dart';
import '../models/LeagueTable.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseMessagingService _fcmService =
      locator<FirebaseMessagingService>();
  bool inProgress = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, model, child) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            color: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Image.asset('assets/images/football_cover.png'),
                  ),
                  const Text(
                    'Welcome to Football Mojo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Text(
                      'The football companion which keeps updated about latest scores and news.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff34648c),
                      ),
                    ),
                  )),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff4285f4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    inProgress = true;
                                  });
                                  final User? user =
                                      await _firebaseService.signInWithGoogle();
                                  if (user == null) {
                                    setState(() {
                                      inProgress = false;
                                    });
                                    return;
                                  }
                                  model.currentUser = user;
                                  await _firestoreService.setData(
                                      userId: user.uid,
                                      data: {
                                        'fcmToken': await _fcmService.getToken()
                                      });
                                  final Map<String, dynamic>? data =
                                      await _firestoreService.getData(
                                          userId: user.uid);
                                  if (data == null) {
                                    setState(() {
                                      inProgress = false;
                                    });
                                    return;
                                  }
                                  if (data.containsKey('teamName') &&
                                      data['teamName'] != null &&
                                      data.containsKey('teamId') &&
                                      data['teamId'] != null &&
                                      data.containsKey('teamLogo') &&
                                      data['teamLogo'] != null &&
                                      data.containsKey('leagueName') &&
                                      data['leagueName'] != null &&
                                      data.containsKey('leagueId') &&
                                      data['leagueId'] != null) {
                                    LocalStorage.setString(
                                        'teamName', data['teamName']);
                                    LocalStorage.setString(
                                        'teamId', data['teamId']);
                                    LocalStorage.setString(
                                        'teamLogo', data['teamLogo']);
                                    LocalStorage.setString(
                                        'leagueName', data['leagueName']);
                                    LocalStorage.setString(
                                        'leagueId', data['leagueId']);
                                    model.selectedLeague = data['leagueName'];
                                    model.leagueWiseScores = [];
                                    model.favouriteTeamScores = [];
                                    model.newsList = [];
                                    model.favouriteNewsList = [];
                                    model.leagueTableEntries = [];
                                    model.navbarIndex = 0;
                                    Navigator.of(context).pushReplacementNamed(
                                        '/home',
                                        arguments: {
                                          'favouriteTeamMessage': {
                                            'title': 'Success',
                                            'content':
                                                '${data['teamName']} added as your favourite team'
                                          },
                                          'showTutorial': true
                                        });
                                  } else {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/selectleague');
                                  }
                                },
                                child: inProgress
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xfff5f5f5)),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              color: Colors.white,
                                              height: 30,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                    'assets/images/google_logo.png'),
                                              )),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Sign in with Google',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/selectleague');
                        },
                        child: const Text(
                          'Continue as guest',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
