import 'package:flutter/material.dart';
import '../services/LoginService.dart';
import '../models/User.dart';
import '../commons/BottomNavbar.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),
      body: Container(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton(
              onPressed: () async{
                final User user = await LoginService().signInWithGoogle();
                print('${user.email} ${user.name} ${user.profilePic}');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/google_logo.png'),
                      )),
                  Text('Sign in with Google', style: TextStyle(color: Colors.white),)
                ],
              ),
              color: Color(0xff4285f4),
            ),
          ),
        ),
      ),
    );
  }
}