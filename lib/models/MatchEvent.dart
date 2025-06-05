class MatchEvent {
  final String type;
  final int minute;
  final String player1;
  final String? player2; // Player 2 (assist) can be null
  final String detail;
  final String team;

  MatchEvent({
    required this.type,
    required this.minute,
    required this.player1,
    this.player2, // Nullable, so not required
    required this.detail,
    required this.team,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> unparsedJson) {
    final timeData = unparsedJson["time"] as Map<String, dynamic>?;
    final playerData = unparsedJson["player"] as Map<String, dynamic>?;
    // Assist data might be null or not present if there's no assist.
    final assistData = unparsedJson["assist"] as Map<String, dynamic>?;
    final teamData = unparsedJson["team"] as Map<String, dynamic>?;

    return MatchEvent(
      type: unparsedJson["type"] as String? ?? 'Unknown',
      minute: timeData?["elapsed"] as int? ?? 0,
      player1: playerData?["name"] as String? ?? 'N/A',
      player2: assistData?["name"] as String?, // Will be null if assistData or name is null
      detail: unparsedJson["detail"] as String? ?? 'N/A',
      team: teamData?["name"] as String? ?? 'N/A',
    );
  }
}