class LeagueTableEntry {
  final int position;
  final String teamName;
  final String? teamLogo; // Nullable
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int loses;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final String? form; // Nullable

  LeagueTableEntry({
    required this.position,
    required this.teamName,
    this.teamLogo,
    required this.matchesPlayed,
    required this.wins,
    required this.draws,
    required this.loses,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    this.form,
  });

  factory LeagueTableEntry.fromJson(Map<String, dynamic> unparsedJson) {
    final teamData = unparsedJson["team"] as Map<String, dynamic>?;
    final allData = unparsedJson["all"] as Map<String, dynamic>?;
    final goalsData = allData?["goals"] as Map<String, dynamic>?;

    return LeagueTableEntry(
      position: unparsedJson["rank"] as int? ?? 0,
      teamName: teamData?["name"] as String? ?? 'N/A',
      teamLogo: teamData?["logo"] as String?,
      matchesPlayed: allData?["played"] as int? ?? 0,
      wins: allData?["win"] as int? ?? 0,
      draws: allData?["draw"] as int? ?? 0,
      loses: allData?["lose"] as int? ?? 0,
      points: unparsedJson["points"] as int? ?? 0,
      goalsFor: goalsData?["for"] as int? ?? 0,
      goalsAgainst: goalsData?["against"] as int? ?? 0,
      form: unparsedJson["form"] as String?,
    );
  }
}