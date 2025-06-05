class Team {
  final String name;
  final String country;
  final String? logo; // Nullable
  final int id;

  Team({
    required this.name,
    required this.country,
    this.logo,
    required this.id,
  });

  factory Team.fromJson(Map<String, dynamic> parsedJson) {
    return Team(
      name: parsedJson['name'] as String? ?? 'N/A',
      country: parsedJson['country'] as String? ?? 'N/A',
      logo: parsedJson['logo'] as String?,
      id: parsedJson['id'] as int? ?? 0,
    );
  }
}