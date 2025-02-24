import 'package:flutter/material.dart';
import 'venue_detail_rsv.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/venue.dart';
import 'carousel_image.dart';
import 'main_scaffold.dart';
class VenueDetailPage extends StatelessWidget {
  final Venue venue;
  const VenueDetailPage(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
      SliverAppBar(
        expandedHeight: 300,
        floating: false,
        pinned: true,
        stretch: true,
        backgroundColor: Colors.black12,
        flexibleSpace: FlexibleSpaceBar(
          background: ImageCarousel(photoUrl: venue.photoUrls),
          titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          centerTitle: false,
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate([
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                const SizedBox(height: 10),
                _placeInfo(),
                VenueDetailRsv(venue),
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              ],
            ),
          ),
        ]),
      ),
        ],
      ),
    );
  }

  Widget _placeInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white24,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconWithText(icon: Icons.location_on, text: venue.address, textColor: Colors.black),
            IconWithText(
                icon: Icons.social_distance,
                text: "${venue.distance.toStringAsPrecision(2)} miles",
                textColor: Colors.black,
            ),
            IconWithText(
                icon: Icons.sports_tennis,
                text: venue.sportCategory.categoryString,
                textColor: Colors.black,
            ),
            IconWithText(
              icon: Icons.attach_money,
              text: "\$${venue.priceInCent / 100}/hr",
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
