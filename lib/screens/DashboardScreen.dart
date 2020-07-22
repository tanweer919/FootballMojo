import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/FirebaseService.dart';
import '../models/User.dart';
import '../commons/BottomNavbar.dart';
import '../Provider/AppProvider.dart';
import '../services/GetItLocator.dart';

class DashboardScreen extends StatelessWidget {
  FirebaseService firebaseService = locator<FirebaseService>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavbar(),
        body: Consumer<AppProvider>(
          builder: (context, model, child) => Container(
              child: (model.currentUser != null) ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Container(
                            height: 40,
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(12.0),
                              child: CachedNetworkImage(
                                  imageUrl: model.currentUser.profilePic,
                                  placeholder: (BuildContext context, String url) =>
                                      Image.asset('assets/images/user-placeholder.jpg')),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                '${model.currentUser.name}',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                              ),
                              Text('${model.currentUser.email}', style: TextStyle(fontSize: 13, color: Color(0X8A000000)),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async{
                          await firebaseService.signOutGoogle();
                          model.currentUser = null;
                        },
                        child: Text('Logout'),
                      )
                    ],
                  )
                ],
              ):
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: RaisedButton(
                    onPressed: () async{
                      final User user = await firebaseService.signInWithGoogle();
                      model.currentUser = user;
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
        ),
      ),
    );
  }
}