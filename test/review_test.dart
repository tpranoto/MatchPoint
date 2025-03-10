import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/review.dart';

void main() {
  test('Create a Review from Map of data.', () {
    final Map<String, dynamic> mockData = {
      "venueId": "vId1",
      "profileId": "pId1",
      "rsvId": "rsvId1",
      "rating": 4,
      "comment": "this is a comment",
      "name": "Hodor",
      "createdAt": Timestamp.fromMillisecondsSinceEpoch(
          DateTime(2025, 02, 25).millisecondsSinceEpoch),
    };

    final review = Review.fromMap(mockData);

    expect(review.venueId, equals("vId1"));
    expect(review.profileId, equals("pId1"));
    expect(review.rsvId, equals("rsvId1"));
    expect(review.rating, equals(4));
    expect(review.comment, equals("this is a comment"));
    expect(review.name, equals("Hodor"));
    expect(review.createdAt, equals(DateTime(2025, 02, 25)));
  });

  test('create Map based on Review object', () {
    final review = Review(
        venueId: "vId1",
        profileId: "pId1",
        rsvId: "rsvId1",
        rating: 4,
        comment: "this is a comment",
        name: "Hodor",
        createdAt: DateTime(2025, 02, 25));
    final reviewMap = review.toMap();

    expect(reviewMap["venueId"], equals("vId1"));
    expect(reviewMap["profileId"], equals("pId1"));
    expect(reviewMap["rsvId"], equals("rsvId1"));
    expect(reviewMap["rating"], equals(4));
    expect(reviewMap["comment"], equals("this is a comment"));
    expect(reviewMap["name"], equals("Hodor"));
    expect(reviewMap["createdAt"], equals(DateTime(2025, 02, 25)));
  });
}
