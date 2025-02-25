import 'package:flutter/material.dart';
import 'venue_detail_rsv.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/venue.dart';
import 'carousel_image.dart';

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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 20.0,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Pop the current screen
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconWithText(
                  icon: Icons.social_distance,
                  text: "${venue.distance.toStringAsPrecision(2)} miles",
                  textColor: Colors.blueGrey,
                ),
              ),
              SizedBox(width: 16), // Space between the two items
              Expanded(
                child: IconWithText(
                  icon: Icons.sports_soccer_outlined,
                  text: venue.sportCategory.categoryString,
                  textColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          IconWithText(
            icon: Icons.attach_money_outlined,
            text: "\$${venue.priceInCent / 100}/hr",
            textColor: Colors.blueGrey,
          ),
          SizedBox(height: 8),
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
