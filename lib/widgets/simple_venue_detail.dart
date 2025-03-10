import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/venue.dart';
import '../providers/review_provider.dart';

class SimpleVenueDetail extends StatelessWidget {
  final Venue venue;
  const SimpleVenueDetail(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: PaddedCard(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                venue.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            VenuePlaceInfo(venue),
          ],
        ),
      ),
    );
  }
}

class VenuePlaceInfo extends StatelessWidget {
  final Venue venue;
  const VenuePlaceInfo(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    final reviewProv = context.watch<ReviewProvider>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconWithText(
                  icon: Icons.sports_soccer_outlined,
                  text: venue.sportCategory.categoryString,
                  textColor: Colors.blueGrey,
                ),
              ),
              Expanded(
                child: venue.ratingsTotal == null && venue.ratings == null ||
                        reviewProv.ratings == 0
                    ? SizedBox.shrink()
                    : RatingStar(
                        rating: reviewProv.ratings,
                        count: reviewProv.venueReviewData.length +
                            (venue.ratingsTotal ?? 0),
                        size: 20,
                        useNumeric: true,
                      ),
              ),
            ],
          ),
          Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconWithText(
                  icon: Icons.social_distance,
                  text: "${venue.distance.toStringAsPrecision(2)} miles",
                  textColor: Colors.blueGrey,
                ),
              ),
              Expanded(
                child: IconWithText(
                  icon: Icons.attach_money_outlined,
                  text: "${venue.priceInCent / 100}/hr",
                  textColor: Colors.blueGrey,
                ),
              )
            ],
          ),
          IconWithText(
            icon: Icons.location_on,
            text: venue.address,
            textColor: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
