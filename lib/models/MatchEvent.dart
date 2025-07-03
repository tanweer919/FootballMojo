import 'dart:convert';

/// A model class representing an event that occurred during a football match.
///
/// This class contains information about match events such as:
/// - Event type (goal, card, substitution, etc.)
/// - Minute of the event
/// - Players involved
/// - Event details
/// - Team involved
class MatchEvent {
  /// Enum representing the possible types of match events.
  static const List<String> validTypes = [
    'Goal',
    'Card',
    'Subst',
    'Var',
    'Penalty',
    'Missed Penalty',
    'Own Goal',
    'Unknown',
  ];

  /// The type of event (e.g., goal, card, substitution).
  final String type;

  /// The minute in the match when the event occurred.
  final int minute;

  /// The name of the primary player involved in the event.
  final String player1;

  /// The name of the secondary player involved in the event (e.g., assist).
  ///
  /// This can be null if there is no secondary player involved.
  final String? player2;

  /// Additional details about the event.
  final String detail;

  /// The name of the team involved in the event.
  final String team;

  /// Creates a new [MatchEvent] instance.
  ///
  /// The [type], [minute], [player1], [detail], and [team] parameters are required.
  /// The [player2] parameter is optional.
  MatchEvent({
    required this.type,
    required this.minute,
    required this.player1,
    this.player2,
    required this.detail,
    required this.team,
  })  : assert(validTypes.contains(type), 'Invalid event type: $type'),
        assert(
            minute >= 0 && minute <= 120, 'Minute must be between 0 and 120'),
        assert(player1.isNotEmpty, 'Player1 name cannot be empty'),
        assert(detail.isNotEmpty, 'Detail cannot be empty'),
        assert(team.isNotEmpty, 'Team name cannot be empty');

  /// Creates a copy of this [MatchEvent] instance with the given fields replaced.
  MatchEvent copyWith({
    String? type,
    int? minute,
    String? player1,
    String? player2,
    String? detail,
    String? team,
  }) {
    return MatchEvent(
      type: type ?? this.type,
      minute: minute ?? this.minute,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      detail: detail ?? this.detail,
      team: team ?? this.team,
    );
  }

  /// Creates a [MatchEvent] instance from a JSON map.
  ///
  /// The [json] parameter must contain at least 'type', 'time', 'player', and 'team' fields.
  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    final timeData = json["time"] as Map<String, dynamic>?;
    final playerData = json["player"] as Map<String, dynamic>?;
    final assistData = json["assist"] as Map<String, dynamic>?;
    final teamData = json["team"] as Map<String, dynamic>?;

    return MatchEvent(
      type: json["type"] as String? ?? 'Unknown',
      minute: timeData?["elapsed"] as int? ?? 0,
      player1: playerData?["name"] as String? ?? 'N/A',
      player2: assistData?["name"] as String?,
      detail: json["detail"] as String? ?? 'N/A',
      team: teamData?["name"] as String? ?? 'N/A',
    );
  }

  /// Converts this [MatchEvent] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'time': {'elapsed': minute},
      'player': {'name': player1},
      if (player2 != null) 'assist': {'name': player2},
      'detail': detail,
      'team': {'name': team},
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchEvent &&
        other.type == type &&
        other.minute == minute &&
        other.player1 == player1 &&
        other.player2 == player2 &&
        other.detail == detail &&
        other.team == team;
  }

  @override
  int get hashCode {
    return Object.hash(type, minute, player1, player2, detail, team);
  }

  @override
  String toString() {
    return 'MatchEvent(type: $type, minute: $minute, player1: $player1, '
        'player2: $player2, detail: $detail, team: $team)';
  }

  /// Creates a [MatchEvent] instance from a JSON string.
  static MatchEvent fromJsonString(String jsonString) {
    return MatchEvent.fromJson(json.decode(jsonString));
  }

  /// Converts this [MatchEvent] instance to a JSON string.
  String toJsonString() {
    return json.encode(toJson());
  }
}
