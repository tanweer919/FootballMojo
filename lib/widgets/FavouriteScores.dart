import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../models/Score.dart';
import '../commons/ScoreCard.dart';

class FavouriteScores extends StatefulWidget {
  @override
  _FavouriteScoresState createState() => _FavouriteScoresState();
}

class _FavouriteScoresState extends State<FavouriteScores> {
  @override
  void initState() {
    super.initState();
    final AppProvider appProvider =
        Provider.of<AppProvider>(context, listen: false);
    if (appProvider.favouriteTeamScores == null) {
      appProvider.loadFavouriteScores();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 30.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final Score score = appProvider.favouriteTeamScores[index];
              return ScoreCard(
                score: score,
              );
              ;
            }),
      ),
    );
  }
}
