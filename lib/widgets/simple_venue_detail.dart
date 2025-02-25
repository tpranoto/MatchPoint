import 'package:flutter/material.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/venue.dart';

class SimpleVenueDetail extends StatelessWidget {
  final Venue venue;
  const SimpleVenueDetail(this.venue, {super.key});

  @override
  Widget build(BuildContext context) {
    return PaddedCard(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CenteredTitle(
            venue.name,
            size: 20,
          ),
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
    );
  }
}
