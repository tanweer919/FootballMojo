import 'package:intl/intl.dart';
class Score{
  String competition;
  String venue;
  String date_time;
  String status;
  String homeTeam;
  String awayTeam;
  String homeTeamLogo;
  String awayTeamLogo;
  int minuteElapsed;
  int homeScore;
  int awayScore;
  Score({this.competition,this.venue, this.date_time, this.status, this.homeTeam, this.awayTeam, this.homeTeamLogo, this.awayTeamLogo, this.homeScore, this.awayScore, this.minuteElapsed});
  Score.fromJson(Map<String, dynamic> parsedJson):
        competition = parsedJson['league']['name'],
        venue = parsedJson['fixture']['venue']['name'],
        date_time = new DateFormat('E, d MMMM, hh:mm aaa').format(DateTime.parse('${parsedJson['fixture']['date'].substring(0, 19)}Z')),
        status = parsedJson['fixture']['status']['short'],
        homeTeam = parsedJson['teams']['home']['name'],
        awayTeam = parsedJson['teams']['away']['name'],
        homeTeamLogo = parsedJson['teams']['home']['logo'],
        awayTeamLogo = parsedJson['teams']['away']['logo'],
        homeScore = parsedJson['goals']['home'],
        awayScore = parsedJson['goals']['away'],
        minuteElapsed = parsedJson['fixture']['status']['elapsed'];
}