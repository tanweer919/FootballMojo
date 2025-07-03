import 'dart:convert';

/// A model class representing a user in the application.
///
/// This class contains basic user information such as:
/// - Unique identifier (uid)
/// - Display name
/// - Email address
/// - Profile picture URL
class User {
  /// The unique identifier for the user.
  final String uid;

  /// The user's display name.
  ///
  /// This can be null if the user hasn't set a display name.
  final String? name;

  /// The user's email address.
  ///
  /// This can be null if the user hasn't provided an email.
  final String? email;

  /// The URL to the user's profile picture.
  ///
  /// This can be null if the user hasn't set a profile picture.
  final String? profilePic;

  /// Creates a new [User] instance.
  ///
  /// The [uid] parameter is required and must not be empty.
  /// All other parameters are optional.
  User({
    required this.uid,
    this.name,
    this.email,
    this.profilePic,
  }) : assert(uid.isNotEmpty, 'User ID cannot be empty');

  /// Creates a [User] instance from a JSON map.
  ///
  /// The [json] parameter must contain at least a 'uid' field.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profilePic: json['profilePic'] as String?,
    );
  }

  /// Converts this [User] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }

  /// Creates a copy of this [User] instance with the given fields replaced.
  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return Object.hash(uid, name, email, profilePic);
  }

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, email: $email, profilePic: $profilePic)';
  }

  /// Creates a [User] instance from a JSON string.
  static User fromJsonString(String jsonString) {
    return User.fromJson(json.decode(jsonString));
  }

  /// Converts this [User] instance to a JSON string.
  String toJsonString() {
    return json.encode(toJson());
  }
}
