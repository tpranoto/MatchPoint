import 'package:flutter/material.dart';
import 'venue_detail_content.dart';
import 'carousel_image.dart';
import '../models/venue.dart';

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
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              VenueDetailContent(venue),
            ]),
          ),
        ],
      ),
    );
  }
}
