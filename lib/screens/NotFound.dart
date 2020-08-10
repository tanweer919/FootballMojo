import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../commons/CustomRaisedButton.dart';
import '../commons/BottomNavbar.dart';
import '../Provider/AppProvider.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset('assets/images/notfound.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom: 4.0),
              child: Text(
                "Looks like you are lost",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 14.0, right: 14.0),
              child: Text(
                "Page you are looking for isn't available.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w300),
              ),
            ),
            CustomRaisedButton(
              label: 'Return to home',
              minWidth: 100,
              height: 40,
              onPressed: () {
                appProvider.navbarIndex = 0;
                Navigator.of(context).pushReplacementNamed('/home');
              },
            )
          ],
        ),
      ),
    );
  }
}