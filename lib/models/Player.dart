class Player {
  int rank;
  int id;
  String name;
  String photoUrl;
  int appearance;
  int goals;
  int penaltyGoals;
  int assists;
  String teamName;
  String teamLogo;
  Player({this.rank, this.id, this.name, this.photoUrl, this.appearance, this.goals, this.penaltyGoals, this.assists, this.teamName, this.teamLogo});
  Player.fromJson(Map<String, dynamic> unparsedJson)
    : id = unparsedJson["player"]["id"],
      name = unparsedJson["player"]["name"],
      photoUrl = unparsedJson["player"]["photo"],
      appearance = unparsedJson["statistics"][0]["games"]["appearences"] ?? 0,
      goals = unparsedJson["statistics"][0]["goals"]["total"] ?? 0,
      penaltyGoals = unparsedJson["statistics"][0]["penalty"]["scored"] ?? 0,
      assists = unparsedJson["statistics"][0]["goals"]["assists"] ?? 0,
      teamName = unparsedJson["statistics"][0]["team"]["name"],
      teamLogo = unparsedJson["statistics"][0]["team"]["logo"];
}