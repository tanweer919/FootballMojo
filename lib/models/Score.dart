class Score{
  String competition;
  String venue;
  String date;
  String time;
  String status;
  String homeTeam;
  String awayTeam;
  String homeTeamLogo;
  String awayTeamLogo;
  int minuteElapsed;
  int homeScore;
  int awayScore;
  Score({this.competition,this.venue, this.date, this.time, this.status, this.homeTeam, this.awayTeam, this.homeTeamLogo, this.awayTeamLogo, this.homeScore, this.awayScore, this.minuteElapsed});
  Score.fromJson(Map<String, dynamic> parsedJson):
        competition = parsedJson['league']['name'],
        venue = parsedJson['fixture']['venue']['name'],
        date = parsedJson['fixture']['date'].substring(0, 10),
        time = parsedJson['fixture']['date'].substring(11, 16),
        status = parsedJson['fixture']['status']['short'],
        homeTeam = parsedJson['teams']['home']['name'],
        awayTeam = parsedJson['teams']['away']['name'],
        homeTeamLogo = parsedJson['teams']['home']['logo'],
        awayTeamLogo = parsedJson['teams']['away']['logo'],
        homeScore = parsedJson['goals']['home'],
        awayScore = parsedJson['goals']['away'],
        minuteElapsed = parsedJson['fixture']['status']['elapsed'];
}