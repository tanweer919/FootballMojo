import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:share/share.dart';
import '../services/FirebaseService.dart';
import '../models/User.dart';
import '../commons/BottomNavbar.dart';
import '../Provider/AppProvider.dart';
import '../services/GetItLocator.dart';
import '../commons/custom_icons.dart';
import '../services/LocalStorage.dart';
import '../services/FirestoreService.dart';
import '../constants.dart';
import '../commons/CustomRaisedButton.dart';
import '../services/FirebaseMessagingService.dart';
import '../Provider/ThemeProvider.dart';
import 'dart:math' show pi;
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseMessagingService _fcmService = locator<FirebaseMessagingService>();
  bool inProgress = false;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: BottomNavbar(),
        body: Consumer<AppProvider>(
          builder: (context, model, child) => Consumer<ThemeProvider>(
              builder: (context, themeModel, child) => SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                  color: themeModel.appTheme == AppTheme.Light ? Colors.white : Color(0XFF1D1D1D)),
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
                                            color: Theme.of(context).primaryColorDark),
                                      )
                                    ],
                                  ),
                                  CustomRaisedButton(
                                    height: 30,
                                    minWidth: 75,
                                    label: 'Logout',
                                    onPressed: () async {
                                      await _firebaseService.signOutGoogle();
                                      model.currentUser = null;
                                    },
                                    inProgress: false,
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
                                  setState(() {
                                    inProgress = true;
                                  });
                                  final User user =
                                  await _firebaseService.signInWithGoogle();
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
                                    ),
                                    'fcmToken': await _fcmService.getToken()
                                  };
                                  await _firestoreService.setData(
                                      userId: user.uid, data: data);
                                  setState(() {
                                    inProgress = false;
                                  });
                                },
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: inProgress ? CircularProgressIndicator(
                                  valueColor:
                                  new AlwaysStoppedAnimation<Color>(Color(0xfff5f5f5)),
                                ) : Row(
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
                                                color: Theme.of(context).primaryColorDark),
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
                                          boxShadow: themeModel.appTheme == AppTheme.Light ? [
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
                                          ] : [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.8),
                                              offset: Offset(-6.0, -6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.1),
                                              offset: Offset(6.0, 6.0),
                                              blurRadius: 16.0,
                                            ),
                                          ],
                                          color: themeModel.appTheme == AppTheme.Light ? Colors.white : Color(0XFF1D1D1D),
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
                                          boxShadow: themeModel.appTheme == AppTheme.Light ? [
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
                                          ] : [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.8),
                                              offset: Offset(-6.0, -6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.1),
                                              offset: Offset(6.0, 6.0),
                                              blurRadius: 16.0,
                                            ),
                                          ],
                                          color: themeModel.appTheme == AppTheme.Light ? Colors.white : Color(0XFF1D1D1D),
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
                                      .pushNamed('/selectleague');
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: themeModel.appTheme == AppTheme.Light ? Color(0X7A000000) : Color(0XFFF5F5F5),
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height:
                        MediaQuery.of(context).size.height /
                            12,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 50,
                              child: Icon(
                                Icons.wb_sunny,
                                color: Color(0xff808080),
                                size: 30,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0),
                                child: Text(
                                  'Theme',
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w300),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: DayNightSwitcher(
                                isDarkModeEnabled: themeModel.appTheme == AppTheme.Dark,
                                onStateChanged: (bool value) async{
                                  if(!value) {
                                    themeModel.appTheme = AppTheme.Light;
                                    await LocalStorage.setString('appTheme', "light");
                                  } else {
                                    themeModel.appTheme = AppTheme.Dark;
                                    await LocalStorage.setString('appTheme', "dark");
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height:
                        MediaQuery.of(context).size.height /
                            12,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 50,
                              child: Icon(
                                Icons.notifications_active,
                                color: Color(0xff808080),
                                size: 30,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0),
                                child: Text(
                                  'Push notifications',
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w300),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: CupertinoSwitch(
                                activeColor: Theme.of(context).primaryColor,
                                  trackColor: Color(0xff56727c),
                                  value: model.notificationEnabled, onChanged: (bool value) async{
                                  model.notificationEnabled = !model.notificationEnabled;
                                  if(value) {
                                    LocalStorage.setString('notificationEnabled', "yes");
                                    await _fcmService.subscribeToTopic(topic: teamName.replaceAll(' ', ''));
                                  } else {
                                    LocalStorage.setString('notificationEnabled', "no");
                                    await _fcmService.unsubscribeFromTopic(topic: teamName.replaceAll(' ', ''));
                                    await LocalStorage.setString('lastTopic', null);
                                  }
                              }),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height:
                        MediaQuery.of(context).size.height /
                            12,
                        child: InkWell(
                          onTap: () {
                            Share.share('Check out this app where you can get latest football news and scores.\nhttps://play.google.com/store?hl=en_IN');
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 50,
                                child: Icon(
                                  Icons.share,
                                  color: Color(0xff808080),
                                  size: 30,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0),
                                  child: Text(
                                    'Share this app',
                                    style: TextStyle(
                                        color: Color(0xff808080),
                                        fontSize: 20,
                                        fontWeight:
                                        FontWeight.w300),
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context)
                                      .primaryColor,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}
