import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Provider/MatchStatViewModel.dart';
import '../Provider/MatchEventViewModel.dart';
import 'package:sportsmojo/commons/custom_icons.dart';
import '../models/Score.dart';
import '../widgets/Stats.dart';
import '../services/GetItLocator.dart';
import 'package:provider/provider.dart';
import '../widgets/Scorers.dart';
import '../constants.dart';
import '../Provider/ThemeProvider.dart';

class MatchStatScreen extends StatefulWidget {
  final Score score;
  const MatchStatScreen({Key? key, required this.score}) : super(key: key);

  @override
  _MatchStatScreenState createState() => _MatchStatScreenState();
}

class _MatchStatScreenState extends State<MatchStatScreen>
    with TickerProviderStateMixin {
  final MatchEventViewModel _matchEventViewModel =
      locator<MatchEventViewModel>();
  final MatchStatViewModel _matchStatViewModel = locator<MatchStatViewModel>();
  late Animation<double> animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation =
        Tween<double>(begin: 20.0, end: 0.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeModel, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: themeModel.appTheme == AppTheme.Light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: (widget.score.status != 'NS')
                ? SingleChildScrollView(
                    child: statSections(themeModel: themeModel),
                  )
                : Container(
                    child: statSections(themeModel: themeModel),
                  ),
          ),
        ),
      ),
    );
  }

  Widget statSections({required ThemeProvider themeModel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '${widget.score.competition} - ${convertDateTime(date_time: widget.score.date_time)}',
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).primaryColorDark),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 40.0,
                    child: Text(
                      (widget.score.status == 'LV')
                          ? "${widget.score.minuteElapsed}'"
                          : "${widget.score.status}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: widget.score.status == 'LV' ? 14 : 12),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  if (widget.score.status == 'LV')
                    Container(
                      width: animation.value,
                      height: 2.0,
                      color: Colors.red,
                    )
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Container(
                        height: 60,
                        child: CachedNetworkImage(
                          imageUrl: widget.score.homeTeamLogo ?? '',
                          placeholder: (BuildContext context, String url) =>
                              Icon(MyFlutterApp.football),
                        ),
                      ),
                    ),
                    FittedBox(
                        child: Text(widget.score.homeTeam),
                        fit: BoxFit.fitWidth),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (widget.score.minuteElapsed != null)
                        ? Text(
                            '${widget.score.homeScore} - ${widget.score.awayScore}',
                            style: const TextStyle(fontSize: 30),
                          )
                        : Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 18,
                              color: themeModel.appTheme == AppTheme.Light
                                  ? const Color(0XAA000000)
                                  : Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: 60,
                        child: CachedNetworkImage(
                          imageUrl: widget.score.awayTeamLogo ?? '',
                          placeholder: (BuildContext context, String url) =>
                              Icon(MyFlutterApp.football),
                        ),
                      ),
                    ),
                    FittedBox(
                        child: Text(widget.score.awayTeam),
                        fit: BoxFit.fitWidth),
                  ],
                ),
              )
            ],
          ),
          const Divider(thickness: 0.7),
          (widget.score.status != 'NS')
              ? ChangeNotifierProvider(
                  create: (context) => _matchEventViewModel,
                  child: Scorer(score: widget.score),
                )
              : getScorer(),
          const Divider(thickness: 0.7),
          (widget.score.status != 'NS')
              ? ChangeNotifierProvider(
                  create: (context) => _matchStatViewModel,
                  child: Stats(score: widget.score),
                )
              : getStats(),
        ],
      ),
    );
  }

  Widget getScorer() {
    return const SizedBox.shrink();
  }

  Widget getStats() {
    return const SizedBox.shrink();
  }

  String convertDateTime({required DateTime date_time}) {
    final DateTime now = DateTime.now();
    final int diffMin = now.difference(date_time).inMinutes;
    final int diffHr = now.difference(date_time).inHours;
    final int diffDay = now.difference(date_time).inDays;

    if (diffMin < 60) {
      return '$diffMin mins';
    } else if (diffMin < 1440) {
      return '$diffHr hrs';
    } else {
      return '$diffDay days';
    }
  }
}
