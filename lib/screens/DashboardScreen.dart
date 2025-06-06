import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:share_plus/share_plus.dart';
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
import '../services/FlushbarHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _sunController; // Changed to late
  late AnimationController _moonController; // Changed to late
  late Animation<Offset> _moonAnimation; // Changed to late

  final FirebaseService _firebaseService = locator<FirebaseService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseMessagingService _fcmService =
      locator<FirebaseMessagingService>();
  bool inProgress = false;
  String? teamLogo, teamName, leagueName, leagueLogo; // Changed to String?

  @override
  void initState() {
    super.initState(); // Call super.initState() first
    _sunController = AnimationController( // Removed new
      vsync: this,
      duration: Duration(milliseconds: 1300), // Removed new
    );
    _moonController = AnimationController( // Removed new
        duration: Duration(milliseconds: 1000), vsync: this)
      ..addListener(() => setState(() {}));
    _moonAnimation = Tween<Offset>(begin: Offset(1.5, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _moonController,
      curve: Cubic(0, 1, .78, .98),
    ));
    LocalStorage.getString('teamName').then((value) {
      if (mounted) { // Check if widget is still in the tree
        setState(() {
          teamName = value;
        });
      }
    });
    LocalStorage.getString('teamLogo').then((value) {
       if (mounted) {
        setState(() { // Ensure teamLogo is updated in setState if UI depends on it directly
          teamLogo = value;
        });
      }
    });
    LocalStorage.getString('leagueName').then((value) {
      if (mounted) {
        setState(() {
          leagueName = value;
          if (leagueName != null) {
            final leagueData = leagues[leagueName!]; // Use ! after null check
            if (leagueData is Map && leagueData.containsKey("logo")) {
              leagueLogo = leagueData["logo"] as String?;
            } else {
              leagueLogo = null;
            }
          } else {
            leagueLogo = null;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sunController.dispose();
    _moonController.dispose();
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
                          color: themeModel.appTheme == AppTheme.Light
                              ? Colors.white
                              : Color(0XFF1D1D1D)),
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
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: CachedNetworkImage(
                                                imageUrl: model.currentUser?.profilePic ?? '', // Handle null profilePic, provide empty or placeholder URL
                                                errorWidget: (context, url, error) => Image.asset('assets/images/user-placeholder.jpg'), // Fallback for error
                                                placeholder: (BuildContext
                                                            context,
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
                                                  model.currentUser?.name ?? 'Guest', // Handle null name
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  model.currentUser?.email ?? 'No email', // Handle null email
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                                )
                                              ],
                                            ),
                                            CustomRaisedButton( // Assuming CustomRaisedButton is null-safe
                                              height: 30,
                                              minWidth: 75,
                                              label: 'Logout',
                                              onPressed: () async {
                                                await _firebaseService
                                                    .signOutGoogle();
                                                model.currentUser = null;
                                              },
                                              inProgress: false, // Assuming this is handled
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row( // User is null, show Sign-in button
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff4285f4),
                                            padding: EdgeInsets.symmetric(horizontal: 4.0), // This padding is for the ElevatedButton itself
                                          ),
                                          onPressed: () async {
                                            if (mounted) { // Check mounted before async operation
                                              setState(() {
                                                inProgress = true;
                                              });
                                            }

                                            final User? user = // User can be null
                                                await _firebaseService
                                                    .signInWithGoogle();

                                            if (!mounted) return; // Check mounted after await

                                            if (user == null) { // Handle failed sign-in
                                                setState(() {
                                                  inProgress = false;
                                                });
                                                // Optionally show a message to the user
                                                FlushHelper.flushbarAlert(context: context, title: "Sign-in Failed", message: "Could not sign in with Google.", seconds: 3);
                                              return;
                                            }

                                            model.currentUser = user; // Assign the user to AppProvider

                                            // Safely access user properties (they are nullable in User model)
                                            final Map<String, dynamic> data = {
                                              'name': user.name, // name is String?
                                              'email': user.email, // email is String?
                                              'teamName':
                                                  await LocalStorage.getString('teamName'), // Returns String?
                                              'teamId':
                                                  await LocalStorage.getString('teamId'), // Returns String?
                                              'teamLogo':
                                                  await LocalStorage.getString('teamLogo'), // Returns String?
                                              'leagueName':
                                                  await LocalStorage.getString('leagueName'), // Returns String?
                                              'leagueId':
                                                  await LocalStorage.getString('leagueId'), // Returns String?
                                              'fcmToken':
                                                  await _fcmService.getToken() // Returns String?
                                            };
                                            // Firestore setData should handle Map<String, dynamic?> or ensure values are not null if required by backend
                                            await _firestoreService.setData(
                                                userId: user.uid, data: data); // uid is non-nullable

                                            if (mounted) {
                                              setState(() {
                                                inProgress = false;
                                              });
                                            }
                                          },
                                          // padding for ElevatedButton content is usually handled by child an its own padding
                                          child: inProgress
                                              ? CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(0xfff5f5f5)),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        color: Colors.white,
                                                        height: 30,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Image.asset(
                                                              'assets/images/google_logo.png'),
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: AutoSizeText(
                                                        'Sign in with Google',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Your Favourites',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Theme.of(context)
                                                        .primaryColorDark),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            decoration: BoxDecoration(
                                              boxShadow: themeModel.appTheme ==
                                                      AppTheme.Light
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        offset:
                                                            Offset(-6.0, -6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        offset:
                                                            Offset(6.0, 6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                    ]
                                                  : [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        offset:
                                                            Offset(-6.0, -6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.white
                                                            .withOpacity(0.1),
                                                        offset:
                                                            Offset(6.0, 6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                    ],
                                              color: themeModel.appTheme ==
                                                      AppTheme.Light
                                                  ? Colors.white
                                                  : Color(0XFF1D1D1D),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 30.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 4.0),
                                                        child: Container(
                                                            height: 40,
                                                            child: leagueLogo !=
                                                                    null
                                                                ? CachedNetworkImage(
                                                                    imageUrl: leagueLogo!, // Added ! after null check
                                                                    errorWidget: (context, url, error) => Icon(MyFlutterApp.football, size: 40),
                                                                    placeholder:
                                                                        (BuildContext context,
                                                                                String url) =>
                                                                            Icon(
                                                                              MyFlutterApp.football,
                                                                              size: 40,
                                                                            ))
                                                                : Icon(
                                                                    MyFlutterApp
                                                                        .football,
                                                                    size: 40,
                                                                  )),
                                                      ),
                                                      Text(
                                                        leagueName ?? 'N/A', // Handle null leagueName
                                                        style: TextStyle(
                                                            fontSize: 18),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            decoration: BoxDecoration(
                                              boxShadow: themeModel.appTheme ==
                                                      AppTheme.Light
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        offset:
                                                            Offset(-6.0, -6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        offset:
                                                            Offset(6.0, 6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                    ]
                                                  : [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        offset:
                                                            Offset(-6.0, -6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.white
                                                            .withOpacity(0.1),
                                                        offset:
                                                            Offset(6.0, 6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                    ],
                                              color: themeModel.appTheme ==
                                                      AppTheme.Light
                                                  ? Colors.white
                                                  : Color(0XFF1D1D1D),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 30.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 4.0),
                                                        child: Container(
                                                            height: 40,
                                                            child: teamLogo != null && teamLogo!.isNotEmpty
                                                                ? CachedNetworkImage(
                                                                    imageUrl: teamLogo!, // Added ! after null check
                                                                    errorWidget: (context, url, error) => Icon(MyFlutterApp.football, size: 40),
                                                                    placeholder:
                                                                        (BuildContext context,
                                                                                String url) =>
                                                                            Icon(
                                                                              MyFlutterApp.football,
                                                                              size: 40,
                                                                            ))
                                                                : Icon(
                                                                    MyFlutterApp
                                                                        .football,
                                                                    size: 40,
                                                                  )),
                                                      ),
                                                      Text(
                                                        teamName ?? 'N/A', // Handle null teamName
                                                        style: TextStyle(
                                                            fontSize: 18),
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
                                      color:
                                          themeModel.appTheme == AppTheme.Light
                                              ? Color(0X7A000000)
                                              : Color(0XFFF5F5F5),
                                      size: 25,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Theme',
                                      style: TextStyle(
                                          color: Color(0xff808080),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: DayNightSwitcher(
                                    isDarkModeEnabled:
                                        themeModel.appTheme == AppTheme.Dark,
                                    onStateChanged: (bool value) async {
                                      // themeModel is a ThemeProvider, appTheme setter notifies listeners
                                      themeModel.appTheme = value ? AppTheme.Dark : AppTheme.Light;
                                      await LocalStorage.setString(
                                          'appTheme', value ? "dark" : "light");
                                      if (!value) {
                                        showSun();
                                      } else {
                                        showMoon();
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Push notifications',
                                      style: TextStyle(
                                          color: Color(0xff808080),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: CupertinoSwitch(
                                      activeTrackColor:
                                          Theme.of(context).primaryColor,
                                      inactiveTrackColor: Color(0xff56727c),
                                      value: model.notificationEnabled, // AppProvider.notificationEnabled is bool
                                      onChanged: (bool value) async {
                                        model.notificationEnabled = value; // Setter in AppProvider
                                        if (value) {
                                          FlushHelper.flushbarAlert(
                                              context: context,
                                              title: 'Success',
                                              message:
                                                  'Push Notications Enabled',
                                              seconds: 2);
                                          await LocalStorage.setString(
                                              'notificationEnabled', "yes");
                                          if (teamName != null && teamName!.isNotEmpty) { // Check teamName for null/empty
                                            await _fcmService.subscribeToTopic(
                                                topic: teamName!.replaceAll(' ', ''));
                                          }
                                        } else {
                                          FlushHelper.flushbarAlert(
                                              context: context,
                                              title: 'Success',
                                              message:
                                                  'Push Notications Disabled',
                                              seconds: 2);
                                          await LocalStorage.setString(
                                              'notificationEnabled', "no");
                                          if (teamName != null && teamName!.isNotEmpty) { // Check teamName for null/empty
                                            await _fcmService.unsubscribeFromTopic(
                                                    topic: teamName!.replaceAll(' ', ''));
                                          }
                                          await LocalStorage.setString('lastTopic', ""); // Set to empty string instead of null
                                        }
                                      }),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            child: InkWell(
                              onTap: () async {
                                await _launchUrlTyped( // Changed to private typed version
                                    'https://play.google.com/store/apps/details?id=com.footballmojo');
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    child: Icon(
                                      Icons.star_border,
                                      color: Color(0xff808080),
                                      size: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        'Rate this app on play store',
                                        style: TextStyle(
                                            color: Color(0xff808080),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Theme.of(context).primaryColor,
                                      size: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            child: InkWell(
                              onTap: () {
                                Share.share(
                                    'Check out this app where you can get latest football news and scores.\nhttps://play.google.com/store/apps/details?id=com.footballmojo');
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
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        'Share this app',
                                        style: TextStyle(
                                            color: Color(0xff808080),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Theme.of(context).primaryColor,
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
                  )),
        ),
      ),
    );
  }

  void showSun() {
    _sunController.repeat();
    Timer? timer = Timer(Duration(milliseconds: 1300), () { // Timer can be nullable
      if(mounted) { // Check if mounted before popping
         Navigator.of(context, rootNavigator: true).pop();
      }
      _sunController.stop(); // Stop controller regardless
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => AnimatedBuilder(
          animation: _sunController,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25),
            child: Image.asset('assets/images/sun.png'),
          ),
          builder: (BuildContext context, Widget? _widget) { // _widget can be nullable
            return Transform.rotate(
              angle: _sunController.value * 3.14,
              child: _widget!, // Assert non-null if child is always provided
            );
          }),
    ).then((value) {
      timer?.cancel(); // Cancel if timer is not null
      timer = null;
    });
  }

  void showMoon() {
    _moonController.reset();
    _moonController.forward();
    Timer? timer = Timer(Duration(milliseconds: 1300), () { // Timer can be nullable
      if(mounted) { // Check if mounted
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3),
              child: Center(
                child: SlideTransition(
                  position: _moonAnimation,
                  child: Container( // Child for SlideTransition should not be null
                    child: Image.asset('assets/images/moon.png'),
                  ),
                ),
              ),
            )).then((value) {
      timer?.cancel(); // Cancel if timer is not null
      timer = null;
    });
  }

  // Updated launchUrl method to _launchUrlTyped for clarity and new url_launcher API
  Future<void> _launchUrlTyped(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Consider showing a Flushbar or SnackBar on failure
      print('Could not launch $url');
      // throw 'Could not launch $url'; // Or handle more gracefully
    }
  }
}
