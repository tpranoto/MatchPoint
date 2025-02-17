import 'package:flutter/material.dart';
import 'venue_detail_page.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/venue.dart';

class HomeVenueCard extends StatelessWidget {
  final Venue venue;
  const HomeVenueCard(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: ImageWithDefault(
          photoUrl: venue.photoUrl,
          defaultAsset: "assets/matchpoint.png",
          size: 56,
        ),
        title: Text(venue.name),
        subtitle: Text(
          "${venue.sportCategory.categoryString} • ${venue.distance.toStringAsPrecision(2)} mi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          "\$${venue.priceInCent / 100}/hr",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VenueDetailPage(venue),
            ),
          );
        },
      ),
    );
  }
}
