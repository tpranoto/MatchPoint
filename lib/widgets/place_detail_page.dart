import 'package:flutter/material.dart';
import 'package:matchpoint/models/static_data.dart';

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    height: 360,
                    width: 360,
                    fit: BoxFit.fill,
                    image: place.photoUrl != null
                        ? NetworkImage(place.photoUrl!)
                        : AssetImage(
                            "assets/matchpoint.png",
                          ),
                  ),
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
            _iconWithText(Icons.location_on, place.address),
            _iconWithText(Icons.sports, place.sportCategory.categoryString),
            _iconWithText(Icons.attach_money, "\$${place.priceInCent / 100}/hr",
                textColor: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _iconWithText(IconData icon, String text,
      {Color textColor = Colors.black}) {
    return Row(
      spacing: 8,
      children: [
        Icon(icon, color: Colors.blueAccent),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}
