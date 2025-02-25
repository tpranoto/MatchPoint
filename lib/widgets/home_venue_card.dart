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
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.surfaceContainer,
              spreadRadius: 2,
              blurRadius: 8),
        ],
      ),
      child: ListTile(
        leading: ImageWithDefault(
          photoUrl: (venue.photoUrls != null && venue.photoUrls!.isNotEmpty)
              ? (venue.photoUrls!..shuffle()).first
              : null,
          defaultAsset: "assets/matchpoint.png",
          size: 56,
        ),
        title: SizedBox(
          height: 48,
          child: Text(
            venue.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          "${venue.sportCategory.categoryString} • ${venue.distance.toStringAsPrecision(2)} mi",
          style: TextStyle(
            fontSize: 14,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: Text(
          "${venue.priceInCent / 100}/hr",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
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
