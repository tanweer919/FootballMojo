class MatchStat {
  final int totalShots;
  final int shotsOnTarget;
  final int possession;
  final int fouls;
  final int yellowCards;
  final int redCards;
  final int offsides;
  final int corners;
  final int saves;
  final int totalPasses;
  final int accuratePasses;

  const MatchStat({
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

  MatchStat copyWith({
    int? totalShots,
    int? shotsOnTarget,
    int? possession,
    int? fouls,
    int? yellowCards,
    int? redCards,
    int? offsides,
    int? corners,
    int? saves,
    int? totalPasses,
    int? accuratePasses,
  }) {
    return MatchStat(
      totalShots: totalShots ?? this.totalShots,
      shotsOnTarget: shotsOnTarget ?? this.shotsOnTarget,
      possession: possession ?? this.possession,
      fouls: fouls ?? this.fouls,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      offsides: offsides ?? this.offsides,
      corners: corners ?? this.corners,
      saves: saves ?? this.saves,
      totalPasses: totalPasses ?? this.totalPasses,
      accuratePasses: accuratePasses ?? this.accuratePasses,
    );
  }

  factory MatchStat.fromJson(Map<String, dynamic> unparsedJson) {
    final List<dynamic> homeStats = unparsedJson['home'] as List<dynamic>;
    final List<dynamic> awayStats = unparsedJson['away'] as List<dynamic>;

    return MatchStat(
      totalShots: _getValue(homeStats, 0, 'value') as int,
      shotsOnTarget: _getValue(homeStats, 1, 'value') as int,
      possession: _getValue(homeStats, 2, 'value') as int,
      fouls: _getValue(homeStats, 3, 'value') as int,
      yellowCards: _getValue(homeStats, 4, 'value') as int,
      redCards: _getValue(homeStats, 5, 'value') as int,
      offsides: _getValue(homeStats, 6, 'value') as int,
      corners: _getValue(homeStats, 7, 'value') as int,
      saves: _getValue(homeStats, 8, 'value') as int,
      totalPasses: _getValue(homeStats, 9, 'value') as int,
      accuratePasses: _getValue(homeStats, 10, 'value') as int,
    );
  }

  static dynamic _getValue(List<dynamic> list, int index, String key) {
    if (index >= list.length) return 0;
    final item = list[index] as Map<String, dynamic>;
    return item[key];
  }
}
