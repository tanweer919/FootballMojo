class MatchEvent {
  String type;
  int minute;
  String player1;
  String player2;
  String detail;
  String team;
  MatchEvent({this.type, this.minute, this.player1, this.player2, this.detail, this.team});
  MatchEvent.fromJson(Map<String, dynamic> unparsedJson)
    : type = unparsedJson["type"],
      minute = unparsedJson["time"]["elapsed"],
      player1 = unparsedJson["player"]["name"],
      player2 = unparsedJson["assist"]["name"],
      detail = unparsedJson["detail"],
      team = unparsedJson["team"]["name"];
}