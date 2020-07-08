
class MatchStat {
  int totalShots;
  int shotsOnTarget;
  String possession;
  int fouls;
  int yellowCards;
  int redCards;
  int offsides;
  int corners;
  int saves;
  int totalPasses;
  String accuratePasses;

  MatchStat(
      {this.totalShots, this.shotsOnTarget, this.possession, this.fouls, this.yellowCards, this.redCards, this.offsides, this.corners, this.saves, this.accuratePasses, this.totalPasses});

  MatchStat.fromJson(List<dynamic> parsedJson)
      : totalShots = parsedJson[2]["value"] ?? 0,
        shotsOnTarget = parsedJson[0]["value"] ?? 0,
        possession = parsedJson[9]["value"],
        fouls = parsedJson[6]["value"] ?? 0,
        yellowCards = parsedJson[10]["value"] ?? 0,
        redCards = parsedJson[11]["value"] ?? 0,
        offsides = parsedJson[8]["value"] ?? 0,
        corners = parsedJson[7]["value"] ?? 0,
        saves = parsedJson[12]["value"] ?? 0,
        totalPasses = parsedJson[13]["value"] ?? 0,
        accuratePasses = parsedJson[15]["value"];
}