import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import '../services/GetItLocator.dart';
import '../services/RemoteConfigService.dart';
import '../services/FirebaseService.dart';
import '../commons/CustomRaisedButton.dart';
import '../Provider/AppProvider.dart';
import '../services/FlushbarHelper.dart';
import '../services/FirebaseMessagingService.dart';

class NoInternetScreen extends StatefulWidget {
  final String from;
  NoInternetScreen({this.from});
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  FirebaseService firebaseService = locator<FirebaseService>();
  final RemoteConfigService _remoteConfigService =
  locator<RemoteConfigService>();
  final FirebaseMessagingService _fcmService = locator<FirebaseMessagingService>();

  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset('assets/images/nointernet.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom: 4.0),
              child: Text(
                "No internet available",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 14.0, right: 14.0),
              child: Text(
                "You are offline. Please turn on your mobile data to get updates.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w300),
              ),
            ),
            CustomRaisedButton(
              label: 'Refresh',
              minWidth: 100,
              height: 40,
              inProgress: inProgress,
              onPressed: () async{
                setState(() {
                  inProgress = true;
                });
                bool result = await DataConnectionChecker().hasConnection;

                if(result == true) {
                  await _fcmService.initialise();
                  await _remoteConfigService.initialise();
                  final currentUser = await firebaseService.getCurrentUser();
                  appProvider.currentUser = currentUser;
                  setState(() {
                    inProgress = false;
                  });
                  Navigator.of(context).pushReplacementNamed('/start');
                }
                else {
                  setState(() {
                    inProgress = false;
                  });
                  FlushHelper.flushbarAlert(context: context, title: 'Error', message: 'You are offline', seconds: 3);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}