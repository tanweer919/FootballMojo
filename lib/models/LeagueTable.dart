class LeagueTableEntry {
  int position;
  String teamName;
  String teamLogo;
  int matchesPlayed;
  int wins;
  int draws;
  int loses;
  int points;
  int goalsFor;
  int goalsAgainst;
  String form;
  LeagueTableEntry({this.position, this.teamName, this.teamLogo, this.matchesPlayed, this.wins, this.draws, this.loses, this.points, this.goalsFor, this.goalsAgainst, this.form});
  LeagueTableEntry.fromJson(Map<String, dynamic> unparsedJson)
    : position = unparsedJson["rank"],
      teamName = unparsedJson["team"]["name"],
      teamLogo = unparsedJson["team"]["logo"],
      matchesPlayed = unparsedJson["all"]["played"],
      wins = unparsedJson["all"]["win"],
      draws = unparsedJson["all"]["draw"],
      loses = unparsedJson["all"]["lose"],
      points = unparsedJson["points"],
      goalsFor = unparsedJson["all"]["goals"]["for"],
      goalsAgainst = unparsedJson["all"]["goals"]["against"],
      form = unparsedJson["form"];
}