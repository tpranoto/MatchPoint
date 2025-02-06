import 'package:flutter/material.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/widgets/common.dart';

import '../models/place.dart';

class PlaceDetailPage extends StatelessWidget {
  final Place place;
  const PlaceDetailPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ImageWithDefault(
                  photoUrl: place.photoUrl,
                  defaultAsset: "assets/matchpoint.png",
                  size: 360,
                ),
                _placeInfo(),
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
            IconWithText(icon: Icons.location_on, text: place.address),
            IconWithText(
                icon: Icons.sports_tennis,
                text: place.sportCategory.categoryString),
            IconWithText(
              icon: Icons.attach_money,
              text: "\$${place.priceInCent / 100}/hr",
              textColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
