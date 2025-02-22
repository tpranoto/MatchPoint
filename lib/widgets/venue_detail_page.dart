import 'package:flutter/material.dart';
import 'venue_detail_rsv.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/venue.dart';

class VenueDetailPage extends StatelessWidget {
  final Venue venue;
  const VenueDetailPage(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Venue", style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    venue.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: ImageWithDefault(
                    photoUrl: venue.photoUrl,
                    defaultAsset: "assets/matchpoint.png",
                    size: 360,
                  ),
                ),
                _placeInfo(),
                Flexible(fit: FlexFit.loose, child: VenueDetailRsv(venue)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconWithText(icon: Icons.location_on, text: venue.address),
            IconWithText(
                icon: Icons.sports_tennis,
                text: venue.sportCategory.categoryString),
            IconWithText(
              icon: Icons.attach_money,
              text: "\$${venue.priceInCent / 100}/hr",
              textColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
