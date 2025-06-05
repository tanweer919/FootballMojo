class MatchStat {
  final int totalShots;
  final int shotsOnTarget;
  final String possession;
  final int fouls;
  final int yellowCards;
  final int redCards;
  final int offsides;
  final int corners;
  final int saves;
  final int totalPasses;
  final String accuratePasses;

  MatchStat({
    required this.totalShots,
    required this.shotsOnTarget,
    required this.possession,
    required this.fouls,
    required this.yellowCards,
    required this.redCards,
    required this.offsides,
    required this.corners,
    required this.saves,
    required this.totalPasses,
    required this.accuratePasses,
  });

  static dynamic _getValue(List<dynamic> list, int index, String key) {
    if (index < list.length) {
      final item = list[index];
      if (item is Map<String, dynamic>) {
        return item[key];
      }
    }
    return null;
  }

  factory MatchStat.fromJson(List<dynamic> parsedJson) {
    // Assuming specific indices correspond to specific stats as per original logic.
    // Providing defaults for all fields.
    return MatchStat(
      totalShots: _getValue(parsedJson, 2, "value") as int? ?? 0,
      shotsOnTarget: _getValue(parsedJson, 0, "value") as int? ?? 0,
      possession: _getValue(parsedJson, 9, "value") as String? ?? "0%",
      fouls: _getValue(parsedJson, 6, "value") as int? ?? 0,
      yellowCards: _getValue(parsedJson, 10, "value") as int? ?? 0,
      redCards: _getValue(parsedJson, 11, "value") as int? ?? 0,
      offsides: _getValue(parsedJson, 8, "value") as int? ?? 0,
      corners: _getValue(parsedJson, 7, "value") as int? ?? 0,
      saves: _getValue(parsedJson, 12, "value") as int? ?? 0,
      totalPasses: _getValue(parsedJson, 13, "value") as int? ?? 0,
      accuratePasses: _getValue(parsedJson, 15, "value") as String? ?? "0%",
    );
  }
}