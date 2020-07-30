import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/NetworkStatusService.dart';
import '../commons/BottomNavbar.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget child;
  NetworkAwareWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkStatus>(builder: (context, model, oldChild) {
      if (model == NetworkStatus.Offline) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.6,
                    child: Image.asset('assets/images/nointernet.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                  child: Text(
                    "No internet available",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 14.0, right: 14.0),
                  child: Text(
                    "You are offline. Please turn on your mobile data to get updates.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return child;
      }
    });
  }
}
