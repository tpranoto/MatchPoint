import 'auth.dart';

class Profile {
  final String id;
  final String email;
  final String name;
  final String photoUrl;
  int reservationsCount;
  int reviewsCount;

  Profile(this.id, this.email, this.name, this.photoUrl, this.reservationsCount,
      this.reviewsCount);

  factory Profile.fromAuth(Auth auth) {
    return Profile(
      auth.uid,
      auth.email,
      auth.displayName,
      auth.photoUrl,
      0,
      0,
    );
  }

  factory Profile.fromMap(Map<String, dynamic> data, String id) {
    return Profile(
      id,
      data["email"],
      data["name"],
      data["photoUrl"],
      data["reservationsCount"] ?? 0,
      data["reviewsCount"] ?? 0,
    );
  }
}
