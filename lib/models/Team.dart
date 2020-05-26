class Team {
  String name;
  String country;
  String logo;
  int id;
  Team({this.name, this.country, this.logo, this.id});
  Team.fromJson(Map<String, dynamic> parsedJson):
      name = parsedJson['name'],
      country = parsedJson['country'],
      logo = parsedJson['logo'],
      id = parsedJson['id'];
}