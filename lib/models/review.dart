import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String venueId;
  final String profileId;
  final String rsvId;
  final int rating;
  final String comment;
  final String name;
  final DateTime createdAt;

  Review(
      {required this.venueId,
      required this.profileId,
      required this.rsvId,
      required this.rating,
      required this.comment,
      required this.name,
      required this.createdAt});

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
        venueId: data["venueId"],
        profileId: data["profileId"],
        rsvId: data["rsvId"],
        rating: data["rating"],
        comment: data["comment"],
        name: data["name"],
        createdAt: (data["createdAt"] as Timestamp).toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      "venueId": venueId,
      "profileId": profileId,
      "rsvId": rsvId,
      "rating": rating,
      "comment": comment,
      "name": name,
      "createdAt": createdAt,
    };
  }
}
