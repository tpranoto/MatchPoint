import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewProvider {
  final CollectionReference _reviewCollection;

  late double _ratings;
  late List<Review> _venueReviewData;

  ReviewProvider(FirebaseFirestore firestore)
      : _reviewCollection = firestore.collection("review");

  List<Review> get venueReviewData => _venueReviewData;
  double get ratings => _ratings;

  Future<void> loadVenueReviews(
      String venueId, double? oldRatings, int? ratingsCount) async {
    final reviewRef = _reviewCollection
        .where("venueId", isEqualTo: venueId)
        .orderBy("createdAt", descending: true);

    final snapshot = await reviewRef.get();
    if (snapshot.size == 0) {
      _venueReviewData = [];
      _ratings = oldRatings ?? 0;
      return;
    }

    _venueReviewData = snapshot.docs
        .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    double inAppRatings = 0;
    for (var review in _venueReviewData) {
      inAppRatings += review.rating;
    }

    if (oldRatings == null) {
      _ratings = inAppRatings;
    } else {
      _ratings = (inAppRatings + (oldRatings * (ratingsCount ?? 0))) /
          ((ratingsCount ?? 0) + _venueReviewData.length);
    }
  }

  Future<void> addMyNewReview(Review review) async {
    final reviewRef = _reviewCollection
        .where("venueId", isEqualTo: review.venueId)
        .where("profileId", isEqualTo: review.profileId)
        .where("rsvId", isEqualTo: review.rsvId);
    final snapshot = await reviewRef.get();

    if (snapshot.size > 0) {
      for (var doc in snapshot.docs) {
        if (!doc.exists) {
          continue;
        }

        await doc.reference.update(review.toMap());
      }
      return;
    }

    await _reviewCollection.add(review.toMap());
  }
}
