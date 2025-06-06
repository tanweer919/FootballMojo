class Score {
  final int id;
  final String competition;
  final String? venue; // Nullable
  final DateTime date_time;
  final String status;
  final String homeTeam;
  final String awayTeam;
  final String? homeTeamLogo; // Nullable
  final String? awayTeamLogo; // Nullable
  final int? minuteElapsed; // Nullable
  final int? homeScore; // Nullable
  final int? awayScore; // Nullable

  Score({
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
      parsedDateTime = DateTime.tryParse('${dateStr.substring(0, 19)}Z') ?? DateTime.now();
    } else {
      parsedDateTime = DateTime.now(); // Default if date string is invalid or null
    }

    String currentStatus = 'NS'; // Default status
    final shortStatus = fixtureStatusData?['short'] as String?;
    if (shortStatus != null && possibleStatus.containsKey(shortStatus)) {
      currentStatus = possibleStatus[shortStatus]!;
    }

    return Score(
      id: fixtureData?['id'] as int? ?? 0,
      competition: leagueData?['name'] as String? ?? 'N/A',
      venue: venueData?['name'] as String?,
      date_time: parsedDateTime,
      status: currentStatus,
      homeTeam: homeTeamData?['name'] as String? ?? 'N/A',
      awayTeam: awayTeamData?['name'] as String? ?? 'N/A',
      homeTeamLogo: homeTeamData?['logo'] as String?,
      awayTeamLogo: awayTeamData?['logo'] as String?,
      homeScore: goalsData?['home'] as int?,
      awayScore: goalsData?['away'] as int?,
      minuteElapsed: fixtureStatusData?['elapsed'] as int?,
    );
  }

  static final Map<String, String> possibleStatus = {
    'TBD': 'NS', // To Be Defined
    'NS': 'NS', // Not Started
    '1H': 'LV',
    'HT': 'HT',
    '2H': 'LV',
    'ET': 'LV', // Extra Time
    'P': 'LV',  // Penalty In Progress (or similar live state)
    'FT': 'FT', // Finished
    'AET': 'FT',// Finished After Extra Time
    'PEN': 'FT',// Finished After Penalties
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
