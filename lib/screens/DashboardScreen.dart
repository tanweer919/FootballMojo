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
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sunController;
  late AnimationController _moonController;
  late Animation<Offset> _moonAnimation;
  Timer? _animationTimer;

  final FirebaseService _firebaseService = locator<FirebaseService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseMessagingService _fcmService =
      locator<FirebaseMessagingService>();

  bool inProgress = false;
  String? teamLogo;
  String? teamName;
  String? leagueName;
  String? leagueLogo;
  bool _notificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserPreferences();
    _loadNotificationState();
  }

  void _initializeControllers() {
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _moonController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addListener(() => setState(() {}));

    _moonAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _moonController,
        curve: const Cubic(0, 1, .78, .98),
      ),
    );
  }

  Future<void> _loadUserPreferences() async {
    if (!mounted) return;

    final preferences = await Future.wait([
      LocalStorage.getString('teamName'),
      LocalStorage.getString('teamLogo'),
      LocalStorage.getString('leagueName'),
    ]);

    setState(() {
      teamName = preferences[0];
      teamLogo = preferences[1];
      leagueName = preferences[2];

      if (leagueName != null) {
        final leagueData = leagues[leagueName!];
        leagueLogo = leagueData is Map && leagueData.containsKey("logo")
            ? leagueData["logo"] as String?
            : null;
      }
    });
  }

  Future<void> _loadNotificationState() async {
    final enabled = await LocalStorage.getString('notificationEnabled');
    if (mounted) {
      setState(() {
        _notificationEnabled = enabled == "yes";
      });
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _sunController.dispose();
    _moonController.dispose();
    super.dispose();
  }

  void showSun() {
    _sunController.reset();
    _sunController.forward();

    _animationTimer?.cancel();
    _animationTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.3,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _sunController,
            builder: (context, _widget) => Transform.rotate(
              angle: _sunController.value * 3.14,
              child: _widget,
            ),
          ),
        ),
      ),
    ).then((_) {
      _animationTimer?.cancel();
      _animationTimer = null;
    });
  }

  void showMoon() {
    _moonController.reset();
    _moonController.forward();

    _animationTimer?.cancel();
    _animationTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.3,
        ),
        child: Center(
          child: SlideTransition(
            position: _moonAnimation,
            child: Image.asset('assets/images/moon.png'),
          ),
        ),
      ),
    ).then((_) {
      _animationTimer?.cancel();
      _animationTimer = null;
    });
  }

  Future<void> _launchUrlTyped(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: BottomNavbar(),
        body: Consumer<AppProvider>(
          builder: (context, model, _) => Consumer<ThemeProvider>(
            builder: (context, themeModel, _) => SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                  color: themeModel.appTheme == AppTheme.Light
                      ? Colors.white
                      : const Color(0XFF1D1D1D),
                ),
                margin: const EdgeInsets.only(top: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildUserProfileSection(context, model, themeModel),
                    _buildThemeSection(context, themeModel),
                    _buildNotificationSection(context),
                    _buildRateAppSection(context),
                    _buildShareAppSection(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(
      BuildContext context, AppProvider model, ThemeProvider themeModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: themeModel.appTheme == AppTheme.Light
                  ? Colors.white
                  : const Color(0XFF1D1D1D),
              boxShadow: [
                BoxShadow(
                  color: themeModel.appTheme == AppTheme.Light
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: model.currentUser != null
                ? _buildLoggedInUserProfile(context, model)
                : _buildGuestUserProfile(context),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/selectleague'),
              child: Icon(
                Icons.edit,
                color: themeModel.appTheme == AppTheme.Light
                    ? const Color(0X7A000000)
                    : const Color(0XFFF5F5F5),
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInUserProfile(BuildContext context, AppProvider model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: model.currentUser?.profilePic ?? '',
                  errorWidget: (_, __, ___) => Image.asset(
                    'assets/images/user-placeholder.jpg',
                    fit: BoxFit.cover,
                  ),
                  placeholder: (_, __) => Image.asset(
                    'assets/images/user-placeholder.jpg',
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      model.currentUser?.name ?? 'Guest',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                    ),
                    Text(
                      model.currentUser?.email ?? 'No email',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestUserProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4285f4),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
              ),
              onPressed: () async {
                if (mounted) {
                  setState(() => inProgress = true);
                  try {
                    final user = await _firebaseService.signInWithGoogle();
                    if (mounted) {
                      context.read<AppProvider>().currentUser = user;
                    }
                  } finally {
                    if (mounted) {
                      setState(() => inProgress = false);
                    }
                  }
                }
              },
              child: inProgress
                  ? const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xfff5f5f5)),
                    )
                  : const Text('Sign in with Google'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeProvider themeModel) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.wb_sunny,
            color: Color(0xff808080),
            size: 30,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                'Theme',
                style: TextStyle(
                  color: Color(0xff808080),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          DayNightSwitcher(
            isDarkModeEnabled: themeModel.appTheme == AppTheme.Dark,
            onStateChanged: (isDarkModeEnabled) {
              themeModel.appTheme =
                  isDarkModeEnabled ? AppTheme.Dark : AppTheme.Light;
              if (isDarkModeEnabled) {
                showMoon();
              } else {
                showSun();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.notifications,
            color: Color(0xff808080),
            size: 30,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                'Push Notifications',
                style: TextStyle(
                  color: Color(0xff808080),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Switch(
            value: _notificationEnabled,
            onChanged: (value) async {
              try {
                if (value) {
                  await LocalStorage.setString('notificationEnabled', "yes");
                  if (teamName != null && teamName!.isNotEmpty) {
                    await _fcmService.subscribeToTopic(
                      topic: teamName!.replaceAll(' ', ''),
                    );
                  }
                  if (mounted) {
                    setState(() => _notificationEnabled = true);
                    FlushHelper.flushbarAlert(
                      context: context,
                      title: 'Success',
                      message: 'Push Notifications Enabled',
                      seconds: 2,
                    );
                  }
                } else {
                  await LocalStorage.setString('notificationEnabled', "no");
                  if (teamName != null && teamName!.isNotEmpty) {
                    await _fcmService.unsubscribeFromTopic(
                      topic: teamName!.replaceAll(' ', ''),
                    );
                  }
                  if (mounted) {
                    setState(() => _notificationEnabled = false);
                    FlushHelper.flushbarAlert(
                      context: context,
                      title: 'Success',
                      message: 'Push Notifications Disabled',
                      seconds: 2,
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  FlushHelper.flushbarAlert(
                    context: context,
                    title: 'Error',
                    message: 'Failed to update notification settings',
                    seconds: 2,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRateAppSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: InkWell(
        onTap: () => _launchUrlTyped(
          'https://play.google.com/store/apps/details?id=com.footballmojo',
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Icon(
                Icons.star_border,
                color: Color(0xff808080),
                size: 30,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Rate this app on play store',
                    style: TextStyle(
                      color: Color(0xff808080),
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Color(0xff808080),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareAppSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: InkWell(
        onTap: () {
          Share.share(
            'Check out this app where you can get latest football news and scores.\nhttps://play.google.com/store/apps/details?id=com.footballmojo',
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Icon(
                Icons.share,
                color: Color(0xff808080),
                size: 30,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Share this app',
                    style: TextStyle(
                      color: Color(0xff808080),
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Color(0xff808080),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
