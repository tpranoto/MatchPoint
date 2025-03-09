import 'package:flutter/material.dart';
import 'package:matchpoint/widgets/venue_detail_reviews.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'main_scaffold.dart';
import 'simple_venue_detail.dart';
import 'venue_detail_rsv.dart';
import '../models/venue.dart';
import '../providers/review_provider.dart';

class VenueDetailContent extends StatelessWidget {
  final Venue venue;
  const VenueDetailContent(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    final reviewProv = context.watch<ReviewProvider>();
    return MPFutureBuilder(
        future: reviewProv.loadVenueReviews(
            venue.id, venue.ratings, venue.ratingsTotal),
        onSuccess: (ctx, snapshot) {
          if (snapshot.hasError) {
            errorDialog(ctx, "${snapshot.error}");
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => MainScaffold()),
                (Route<dynamic> route) => false);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
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
                VenueDetailRsv(venue),
                SizedBox(height: 20),
                venue.ratingsTotal == null && venue.ratings == null ||
                        reviewProv.ratings == 0
                    ? SizedBox.shrink()
                    : VenueDetailReviews(venue),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          );
        });
  }
}
