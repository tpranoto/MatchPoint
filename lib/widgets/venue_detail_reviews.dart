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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CenteredTitle("Customer Ratings & Reviews", size: 16),
          CenteredTitle("${reviewProv.ratings}", size: 32),
          RatingStar(
              rating: reviewProv.ratings,
              count:
                  reviewProv.venueReviewData.length + (venue.ratingsTotal ?? 0),
              isCentered: true),
          Text(
              "${reviewProv.venueReviewData.length + (venue.ratingsTotal ?? 0)} ratings"),
          SizedBox(height: 20),
          reviewProv.venueReviewData.isEmpty
              ? SizedBox.shrink()
              : CenteredTitle("Reviews"),
          ...reviewProv.venueReviewData.map((review) => VenueDetailsReviewCard(
              review,
              reviewProv.venueReviewData.length + (venue.ratingsTotal ?? 0))),
        ],
      ),
    );
  }
}

class VenueDetailsReviewCard extends StatelessWidget {
  final Review review;
  final int reviewCount;
  const VenueDetailsReviewCard(this.review, this.reviewCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(review.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingStar(
                rating: review.rating.toDouble(),
                count: reviewCount,
                useNumeric: true),
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}
