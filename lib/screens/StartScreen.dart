import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/FirebaseService.dart';
import '../services/FirestoreService.dart';
import '../services/LocalStorage.dart';
import '../services/GetItLocator.dart';
import '../Provider/AppProvider.dart';
import '../models/User.dart';

class StartScreen extends StatelessWidget {
  FirebaseService firebaseService = locator<FirebaseService>();
  FirestoreService firestoreService = locator<FirestoreService>();

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Image.asset('assets/images/football_cover.svg'),
                  ),
                  Text(
                    'Football just it was meant to be',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'You can get football scores and news directly from your home...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff34648c),
                      ),
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: RaisedButton(
                            onPressed: () async {
                              final User user =
                                  await firebaseService.signInWithGoogle();
                              model.currentUser = user;
                              final Map<String, dynamic> data = {
                                'name': user.name,
                                'email': user.email,
                                'teamName': await LocalStorage.getString(
                                  'teamName',
                                ),
                                'teamId': await LocalStorage.getString(
                                  'teamId',
                                ),
                                'teamLogo': await LocalStorage.getString(
                                  'teamLogo',
                                ),
                                'leagueName':
                                    await LocalStorage.getString('leagueName'),
                                'leagueId': await LocalStorage.getString(
                                  'leagueId',
                                )
                              };
                              await firestoreService.setData(
                                  userId: user.uid, data: data);
                            },
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    color: Colors.white,
                                    height: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                          'assets/images/google_logo.png'),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    'Sign in with Google',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            color: Color(0xff4285f4),
                          ),
                        )
                      ],
                    ),
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
