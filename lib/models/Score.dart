import 'package:intl/intl.dart';

class Score {
  int id;
  String competition;
  String venue;
  DateTime date_time;
  String status;
  String homeTeam;
  String awayTeam;
  String homeTeamLogo;
  String awayTeamLogo;
  int minuteElapsed;
  int homeScore;
  int awayScore;
  Score(
      {this.id,
      this.competition,
      this.venue,
      this.date_time,
      this.status,
      this.homeTeam,
      this.awayTeam,
      this.homeTeamLogo,
      this.awayTeamLogo,
      this.homeScore,
      this.awayScore,
      this.minuteElapsed});
  Score.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['fixture']['id'],
        competition = parsedJson['league']['name'],
        venue = parsedJson['fixture']['venue']['name'],
        date_time = DateTime.parse(
            '${parsedJson['fixture']['date'].substring(0, 19)}Z'),
        status = possibleStatus[parsedJson['fixture']['status']['short']],
        homeTeam = parsedJson['teams']['home']['name'],
        awayTeam = parsedJson['teams']['away']['name'],
        homeTeamLogo = parsedJson['teams']['home']['logo'],
        awayTeamLogo = parsedJson['teams']['away']['logo'],
        homeScore = parsedJson['goals']['home'],
        awayScore = parsedJson['goals']['away'],
        minuteElapsed = parsedJson['fixture']['status']['elapsed'];
  static final Map<String, String> possibleStatus = {
    'TBD': 'NS',
    'NS': 'NS',
    '1H': 'LV',
    'HT': 'HT',
    '2H': 'LV',
    'ET': 'LV',
    'P': 'LV',
    'FT': 'FT',
    'AET': 'FT',
    'PEN': 'FT',
    'BT': 'LV',
    'SUSP': 'SUSP',
    'INT': 'INT',
    'PST': 'PST',
    'CANC': 'CANC',
    'ABD': 'ABD',
    'AWD': 'AWD',
    'WO': 'WO'
  };
}
