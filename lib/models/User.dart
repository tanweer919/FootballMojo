class User {
  final String uid;
  final String? name; // Nullable
  final String? email; // Nullable
  final String? profilePic; // Nullable

  User({
    required this.uid,
    this.name,
    this.email,
    this.profilePic,
  });
}