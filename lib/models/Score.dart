class Score {
  final int id;
  final String competition;
  final String? venue;
  final DateTime date_time;
  final String status;
  final String homeTeam;
  final String awayTeam;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final int? minuteElapsed;
  final int? homeScore;
  final int? awayScore;

  const Score({
    required this.id,
    required this.competition,
    this.venue,
    required this.date_time,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.homeScore,
    this.awayScore,
    this.minuteElapsed,
  });

  Score copyWith({
    int? id,
    String? competition,
    String? venue,
    DateTime? date_time,
    String? status,
    String? homeTeam,
    String? awayTeam,
    String? homeTeamLogo,
    String? awayTeamLogo,
    int? homeScore,
    int? awayScore,
    int? minuteElapsed,
  }) {
    return Score(
      id: id ?? this.id,
      competition: competition ?? this.competition,
      venue: venue ?? this.venue,
      date_time: date_time ?? this.date_time,
      status: status ?? this.status,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeTeamLogo: homeTeamLogo ?? this.homeTeamLogo,
      awayTeamLogo: awayTeamLogo ?? this.awayTeamLogo,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      minuteElapsed: minuteElapsed ?? this.minuteElapsed,
    );
  }

  factory Score.fromJson(Map<String, dynamic> parsedJson) {
    final fixtureData = parsedJson['fixture'] as Map<String, dynamic>?;
    final leagueData = parsedJson['league'] as Map<String, dynamic>?;
    final teamsData = parsedJson['teams'] as Map<String, dynamic>?;
    final homeTeamData = teamsData?['home'] as Map<String, dynamic>?;
    final awayTeamData = teamsData?['away'] as Map<String, dynamic>?;
    final goalsData = parsedJson['goals'] as Map<String, dynamic>?;
    final venueData = fixtureData?['venue'] as Map<String, dynamic>?;
    final fixtureStatusData = fixtureData?['status'] as Map<String, dynamic>?;

    DateTime parsedDateTime;
    final dateStr = fixtureData?['date'] as String?;
    if (dateStr != null && dateStr.length >= 19) {
      parsedDateTime =
          DateTime.tryParse('${dateStr.substring(0, 19)}Z') ?? DateTime.now();
    } else {
      parsedDateTime = DateTime.now();
    }

    String currentStatus = 'NS';
    final shortStatus = fixtureStatusData?['short'] as String?;
    if (shortStatus != null && possibleStatus.containsKey(shortStatus)) {
      currentStatus = possibleStatus[shortStatus]!;
    }

    final fixtureId = fixtureData?['id'];
    if (fixtureId == null) {
      throw FormatException('Fixture ID is required');
    }

    final leagueName = leagueData?['name'] as String?;
    if (leagueName == null) {
      throw FormatException('League name is required');
    }

    final homeTeamName = homeTeamData?['name'] as String?;
    if (homeTeamName == null) {
      throw FormatException('Home team name is required');
    }

    final awayTeamName = awayTeamData?['name'] as String?;
    if (awayTeamName == null) {
      throw FormatException('Away team name is required');
    }

    return Score(
      id: fixtureId as int,
      competition: leagueName,
      venue: venueData?['name'] as String?,
      date_time: parsedDateTime,
      status: currentStatus,
      homeTeam: homeTeamName,
      awayTeam: awayTeamName,
      homeTeamLogo: homeTeamData?['logo'] as String?,
      awayTeamLogo: awayTeamData?['logo'] as String?,
      homeScore: goalsData?['home'] as int?,
      awayScore: goalsData?['away'] as int?,
      minuteElapsed: fixtureStatusData?['elapsed'] as int?,
    );
  }

  static const Map<String, String> possibleStatus = {
    'TBD': 'NS', // To Be Defined
    'NS': 'NS', // Not Started
    '1H': 'LV',
    'HT': 'HT',
    '2H': 'LV',
    'ET': 'LV', // Extra Time
    'P': 'LV', // Penalty In Progress (or similar live state)
    'FT': 'FT', // Finished
    'AET': 'FT', // Finished After Extra Time
    'PEN': 'FT', // Finished After Penalties
    'BT': 'LV', // Break Time (e.g. before ET or Penalties)
    'SUSP': 'SUSP', // Suspended
    'INT': 'INT', // Interrupted
    'PST': 'PST', // Postponed
    'CANC': 'CANC', // Cancelled
    'ABD': 'ABD', // Abandoned
    'AWD': 'AWD', // Technical Loss (Awarded)
    'WO': 'WO' // WalkOver
  };
}
