class Player {
  final int? rank;
  final int id;
  final String name;
  final String? photoUrl; // Nullable
  final int appearance;
  final int goals;
  final int penaltyGoals;
  final int assists;
  final String teamName;
  final String? teamLogo; // Nullable

  const Player({
    this.rank,
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

  Player copyWith({
    int? rank,
    int? id,
    String? name,
    String? photoUrl,
    int? appearance,
    int? goals,
    int? penaltyGoals,
    int? assists,
    String? teamName,
    String? teamLogo,
  }) {
    return Player(
      rank: rank ?? this.rank,
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      appearance: appearance ?? this.appearance,
      goals: goals ?? this.goals,
      penaltyGoals: penaltyGoals ?? this.penaltyGoals,
      assists: assists ?? this.assists,
      teamName: teamName ?? this.teamName,
      teamLogo: teamLogo ?? this.teamLogo,
    );
  }

  factory Player.fromJson(Map<String, dynamic> unparsedJson, int rank) {
    final playerData = unparsedJson["player"] as Map<String, dynamic>?;
    if (playerData == null) {
      throw FormatException('Player data is required');
    }

    final statsList = unparsedJson["statistics"] as List<dynamic>?;
    if (statsList == null || statsList.isEmpty) {
      throw FormatException('Statistics data is required');
    }

    final firstStat = statsList[0] as Map<String, dynamic>?;
    if (firstStat == null) {
      throw FormatException('First statistics entry is required');
    }

    final gamesData = firstStat["games"] as Map<String, dynamic>?;
    if (gamesData == null) {
      throw FormatException('Games data is required');
    }

    final goalsData = firstStat["goals"] as Map<String, dynamic>?;
    if (goalsData == null) {
      throw FormatException('Goals data is required');
    }

    final penaltyData = firstStat["penalty"] as Map<String, dynamic>?;
    if (penaltyData == null) {
      throw FormatException('Penalty data is required');
    }

    final teamData = firstStat["team"] as Map<String, dynamic>?;
    if (teamData == null) {
      throw FormatException('Team data is required');
    }

    final id = playerData["id"] as int?;
    if (id == null) {
      throw FormatException('Player ID is required');
    }

    final name = playerData["name"] as String?;
    if (name == null) {
      throw FormatException('Player name is required');
    }

    final appearance = gamesData["appearences"] as int?;
    if (appearance == null) {
      throw FormatException('Appearances is required');
    }

    final goals = goalsData["total"] as int?;
    if (goals == null) {
      throw FormatException('Goals is required');
    }

    final penaltyGoals = penaltyData["scored"] as int?;
    if (penaltyGoals == null) {
      throw FormatException('Penalty goals is required');
    }

    final assists = goalsData["assists"] as int?;
    if (assists == null) {
      throw FormatException('Assists is required');
    }

    final teamName = teamData["name"] as String?;
    if (teamName == null) {
      throw FormatException('Team name is required');
    }

    return Player(
      id: id,
      name: name,
      photoUrl: playerData["photo"] as String?,
      appearance: appearance,
      goals: goals,
      penaltyGoals: penaltyGoals,
      assists: assists,
      teamName: teamName,
      teamLogo: teamData["logo"] as String?,
      rank: rank,
    );
  }
}
