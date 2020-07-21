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
      appearance = unparsedJson["statistics"]["games"]["appearences"],
      goals = unparsedJson["statistics"]["goals"]["total"],
      penaltyGoals = unparsedJson["statistics"]["penalty"]["scored"],
      assists = unparsedJson["statistics"]["goals"]["assists"],
      teamName = unparsedJson["statistics"]["team"]["name"],
      teamLogo = unparsedJson["statistics"]["team"]["logo"];
}