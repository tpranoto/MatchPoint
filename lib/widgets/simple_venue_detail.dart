import 'package:flutter/material.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/venue.dart';

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
            _PlaceInfo(venue),
          ],
        ),
      ),
    );
  }
}

class _PlaceInfo extends StatelessWidget {
  final Venue venue;
  const _PlaceInfo(this.venue);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                  icon: Icons.social_distance,
                  text: "${venue.distance.toStringAsPrecision(2)} miles",
                  textColor: Colors.blueGrey,
                ),
              ),
              Expanded(
                child: IconWithText(
                  icon: Icons.sports_soccer_outlined,
                  text: venue.sportCategory.categoryString,
                  textColor: Colors.blueGrey,
                ),
              ),
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
