import 'dart:convert';

/// A model class representing a football team.
///
/// This class contains basic team information such as:
/// - Team name
/// - Country
/// - Logo URL
/// - Team ID
class Team {
  /// The name of the team.
  final String name;

  /// The country the team is from.
  final String country;

  /// The URL to the team's logo.
  ///
  /// This can be null if the team doesn't have a logo.
  final String? logo;

  /// The unique identifier for the team.
  final int id;

  /// Creates a new [Team] instance.
  ///
  /// The [name], [country], and [id] parameters are required.
  /// The [logo] parameter is optional.
  Team({
    required this.name,
    required this.country,
    this.logo,
    required this.id,
  })  : assert(name.isNotEmpty, 'Team name cannot be empty'),
        assert(country.isNotEmpty, 'Country name cannot be empty'),
        assert(id > 0, 'Team ID must be positive');

  /// Creates a copy of this [Team] instance with the given fields replaced.
  Team copyWith({
    String? name,
    String? country,
    String? logo,
    int? id,
  }) {
    return Team(
      name: name ?? this.name,
      country: country ?? this.country,
      logo: logo ?? this.logo,
      id: id ?? this.id,
    );
  }

  /// Creates a [Team] instance from a JSON map.
  ///
  /// The [json] parameter must contain at least 'name', 'country', and 'id' fields.
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'] as String? ?? 'N/A',
      country: json['country'] as String? ?? 'N/A',
      logo: json['logo'] as String?,
      id: json['id'] as int? ?? 0,
    );
  }

  /// Converts this [Team] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'logo': logo,
      'id': id,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Team &&
        other.name == name &&
        other.country == country &&
        other.logo == logo &&
        other.id == id;
  }

  @override
  int get hashCode {
    return Object.hash(name, country, logo, id);
  }

  @override
  String toString() {
    return 'Team(name: $name, country: $country, logo: $logo, id: $id)';
  }

  /// Creates a [Team] instance from a JSON string.
  static Team fromJsonString(String jsonString) {
    return Team.fromJson(json.decode(jsonString));
  }

  /// Converts this [Team] instance to a JSON string.
  String toJsonString() {
    return json.encode(toJson());
  }
}
