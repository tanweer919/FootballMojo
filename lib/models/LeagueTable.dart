class LeagueTableEntry {
  final int position;
  final String teamName;
  final String? teamLogo;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int loses;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final String? form;

  const LeagueTableEntry({
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

  LeagueTableEntry copyWith({
    int? position,
    String? teamName,
    String? teamLogo,
    int? matchesPlayed,
    int? wins,
    int? draws,
    int? loses,
    int? points,
    int? goalsFor,
    int? goalsAgainst,
    String? form,
  }) {
    return LeagueTableEntry(
      position: position ?? this.position,
      teamName: teamName ?? this.teamName,
      teamLogo: teamLogo ?? this.teamLogo,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      draws: draws ?? this.draws,
      loses: loses ?? this.loses,
      points: points ?? this.points,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      form: form ?? this.form,
    );
  }

  factory LeagueTableEntry.fromJson(Map<String, dynamic> unparsedJson) {
    final teamData = unparsedJson["team"] as Map<String, dynamic>?;
    if (teamData == null) {
      throw FormatException('Team data is required');
    }

    final allData = unparsedJson["all"] as Map<String, dynamic>?;
    if (allData == null) {
      throw FormatException('All data is required');
    }

    final goalsData = allData["goals"] as Map<String, dynamic>?;
    if (goalsData == null) {
      throw FormatException('Goals data is required');
    }

    final position = unparsedJson["rank"] as int?;
    if (position == null) {
      throw FormatException('Position is required');
    }

    final teamName = teamData["name"] as String?;
    if (teamName == null) {
      throw FormatException('Team name is required');
    }

    final matchesPlayed = allData["played"] as int?;
    if (matchesPlayed == null) {
      throw FormatException('Matches played is required');
    }

    final wins = allData["win"] as int?;
    if (wins == null) {
      throw FormatException('Wins is required');
    }

    final draws = allData["draw"] as int?;
    if (draws == null) {
      throw FormatException('Draws is required');
    }

    final loses = allData["lose"] as int?;
    if (loses == null) {
      throw FormatException('Loses is required');
    }

    final points = unparsedJson["points"] as int?;
    if (points == null) {
      throw FormatException('Points is required');
    }

    final goalsFor = goalsData["for"] as int?;
    if (goalsFor == null) {
      throw FormatException('Goals for is required');
    }

    final goalsAgainst = goalsData["against"] as int?;
    if (goalsAgainst == null) {
      throw FormatException('Goals against is required');
    }

    return LeagueTableEntry(
      position: position,
      teamName: teamName,
      teamLogo: teamData["logo"] as String?,
      matchesPlayed: matchesPlayed,
      wins: wins,
      draws: draws,
      loses: loses,
      points: points,
      goalsFor: goalsFor,
      goalsAgainst: goalsAgainst,
      form: unparsedJson["form"] as String?,
    );
  }
}
