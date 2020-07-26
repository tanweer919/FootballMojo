import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/FirebaseService.dart';
import '../models/User.dart';
import '../commons/BottomNavbar.dart';
import '../Provider/AppProvider.dart';
import '../services/GetItLocator.dart';
import '../commons/custom_icons.dart';
import '../services/LocalStorage.dart';
import '../services/FirestoreService.dart';
import '../constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  FirebaseService firebaseService = locator<FirebaseService>();
  FirestoreService firestoreService = locator<FirestoreService>();
  String teamLogo, teamName, leagueName, leagueLogo;

  @override
  void initState() {
    LocalStorage.getString('teamName').then((value) {
      setState(() {
        teamName = value;
      });
    });
    LocalStorage.getString('teamLogo').then((value) {
      teamLogo = value;
    });
    LocalStorage.getString('leagueName').then((value) {
      leagueName = value;
      leagueLogo = leagues[leagueName]["logo"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: BottomNavbar(),
        body: Consumer<AppProvider>(
          builder: (context, model, child) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
                color: Colors.white),
            margin: EdgeInsets.only(top: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 8.0, right: 8.0, bottom: 8.0),
                  child: (model.currentUser != null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                      imageUrl: model.currentUser.profilePic,
                                      placeholder: (BuildContext context,
                                              String url) =>
                                          Image.asset(
                                              'assets/images/user-placeholder.jpg')),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        '${model.currentUser.name}',
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '${model.currentUser.email}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0X8A000000)),
                                      )
                                    ],
                                  ),
                                  ButtonTheme(
                                    height: 30,
                                    minWidth: 75,
                                    child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                      ),
                                      onPressed: () async {
                                        await firebaseService.signOutGoogle();
                                        model.currentUser = null;
                                      },
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
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
                                    'leagueName': await LocalStorage.getString(
                                        'leagueName'),
                                    'leagueId': await LocalStorage.getString(
                                      'leagueId',
                                    )
                                  };
                                  await firestoreService.setData(
                                      userId: user.uid, data: data);
                                },
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                ),
                Divider(
                  thickness: 0.7,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Your Favourites',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0X8A000000)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.8),
                                        offset: Offset(-6.0, -6.0),
                                        blurRadius: 16.0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(6.0, 6.0),
                                        blurRadius: 16.0,
                                      ),
                                    ],
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Container(
                                                  height: 40,
                                                  child: leagueLogo != null
                                                      ? CachedNetworkImage(
                                                          imageUrl: leagueLogo,
                                                          placeholder:
                                                              (BuildContext
                                                                          context,
                                                                      String
                                                                          url) =>
                                                                  Icon(
                                                                    MyFlutterApp
                                                                        .football,
                                                                    size: 40,
                                                                  ))
                                                      : Icon(
                                                          MyFlutterApp.football,
                                                          size: 40,
                                                        )),
                                            ),
                                            Text(
                                              leagueName,
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.8),
                                        offset: Offset(-6.0, -6.0),
                                        blurRadius: 16.0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(6.0, 6.0),
                                        blurRadius: 16.0,
                                      ),
                                    ],
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Container(
                                                  height: 40,
                                                  child: teamLogo != null
                                                      ? CachedNetworkImage(
                                                          imageUrl: teamLogo,
                                                          placeholder:
                                                              (BuildContext
                                                                          context,
                                                                      String
                                                                          url) =>
                                                                  Icon(
                                                                    MyFlutterApp
                                                                        .football,
                                                                    size: 40,
                                                                  ))
                                                      : Icon(
                                                          MyFlutterApp.football,
                                                          size: 40,
                                                        )),
                                            ),
                                            Text(
                                              teamName,
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/selectleague');
                          },
                          child: Icon(
                            Icons.edit,
                            color: Color(0x7a000000),
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
