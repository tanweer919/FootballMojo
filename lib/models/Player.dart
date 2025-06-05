class Player {
  int? rank; // Nullable, intended to be set externally after creation
  final int id;
  final String name;
  final String? photoUrl; // Nullable
  final int appearance;
  final int goals;
  final int penaltyGoals;
  final int assists;
  final String teamName;
  final String? teamLogo; // Nullable

  Player({
    this.rank, // Keep as optional, will be null initially from fromJson
    required this.id,
    required this.name,
    this.photoUrl,
    required this.appearance,
    required this.goals,
    required this.penaltyGoals,
    required this.assists,
    required this.teamName,
    this.teamLogo,
  });

  factory Player.fromJson(Map<String, dynamic> unparsedJson) {
    final playerData = unparsedJson["player"] as Map<String, dynamic>?;
    final statsList = unparsedJson["statistics"] as List<dynamic>?;
    Map<String, dynamic>? firstStat;
    if (statsList != null && statsList.isNotEmpty) {
      firstStat = statsList[0] as Map<String, dynamic>?;
    }

    final gamesData = firstStat?["games"] as Map<String, dynamic>?;
    final goalsData = firstStat?["goals"] as Map<String, dynamic>?;
    final penaltyData = firstStat?["penalty"] as Map<String, dynamic>?;
    final teamData = firstStat?["team"] as Map<String, dynamic>?;

    return Player(
      // rank is not set here, will be null by default. Set by TopScorerService.
      id: playerData?["id"] as int? ?? 0,
      name: playerData?["name"] as String? ?? 'N/A',
      photoUrl: playerData?["photo"] as String?,
      appearance: gamesData?["appearences"] as int? ?? 0, // Note: "appearences" might be a typo in original JSON for "appearances"
      goals: goalsData?["total"] as int? ?? 0,
      penaltyGoals: penaltyData?["scored"] as int? ?? 0,
      assists: goalsData?["assists"] as int? ?? 0,
      teamName: teamData?["name"] as String? ?? 'N/A',
      teamLogo: teamData?["logo"] as String?,
    );
  }
}