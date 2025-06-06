import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import '../models/venue.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';

class VenueDetailReviews extends StatelessWidget {
  final Venue venue;
  const VenueDetailReviews(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    final reviewProv = context.watch<ReviewProvider>();
    final totalReviews =
        reviewProv.venueReviewData.length + (venue.ratingsTotal ?? 0);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              title("Customer Ratings & Reviews", 18, FontWeight.bold),
              const SizedBox(height: 6),
              Text(reviewProv.ratings.toStringAsPrecision(2),
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
              const SizedBox(height: 6),
              RatingStar(
                  rating: reviewProv.ratings,
                  count: totalReviews,
                  isCentered: true),
              const SizedBox(height: 4),
              Text("$totalReviews ratings",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              const SizedBox(height: 20),
              if (reviewProv.venueReviewData.isNotEmpty)
                title("Reviews", 16, FontWeight.w600),
              const SizedBox(height: 8),
              ...reviewProv.venueReviewData.map(
                  (review) => VenueDetailsReviewCard(review, totalReviews)),
            ],
          ),
        ),
      ),
    );
  }

  Widget title(String text, double size, FontWeight weight) => Text(
        text,
        style: TextStyle(fontSize: size, fontWeight: weight),
        textAlign: TextAlign.center,
      );
}

class VenueDetailsReviewCard extends StatelessWidget {
  final Review review;
  final int reviewCount;
  const VenueDetailsReviewCard(this.review, this.reviewCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(
              review.createdAt.toLocal().toString().split(' ')[0],
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingStar(
                rating: review.rating.toDouble(),
                count: reviewCount,
                useNumeric: false),
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}
