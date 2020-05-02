import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              'Sports Mojo',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
      )
    );
  }
}