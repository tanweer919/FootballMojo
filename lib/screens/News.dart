import 'package:flutter/material.dart';
import '../commons/BottomNavbar.dart';

class NewsScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavbar(),
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: SelectableText(
                'News',
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