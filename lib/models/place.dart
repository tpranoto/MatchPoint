import 'package:flutter/foundation.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/timeslot.dart';

class Place {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final String? photoUrl;
  final SportsCategories sportCategory;
  final int priceInCent;
  final List<String> availableTimeslots;
  final double? ratings;
  final int? ratingsTotal;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.photoUrl,
    required this.sportCategory,
    required this.priceInCent,
    required this.availableTimeslots,
    required this.ratings,
    required this.ratingsTotal,
  });

  factory Place.fromResponse(Map<String, dynamic> data) {
    final mainGeocodes = data["geocodes"]["main"];
    final List<dynamic> photos = data["photos"];
    String? photoUrl;
    if (photos.isNotEmpty) {
      photoUrl = "${photos.last["prefix"]}original${photos.last["suffix"]}";
    }

    final List<dynamic> categories = data["categories"];
    final currCategory = categoryEnum(categories[0]["name"]);
    final double metersInOneMile = 1609.344;

    int? ratingTotal = 0;
    if (data["stats"] != null) {
      ratingTotal = data["stats"]["total_ratings"];
    }

    return Place(
      id: data["fsq_id"],
      name: data["name"],
      address: data["location"]["formatted_address"],
      latitude: mainGeocodes["latitude"],
      longitude: mainGeocodes["longitude"],
      distance: data["distance"] / metersInOneMile,
      photoUrl: photoUrl,
      sportCategory: currCategory,
      priceInCent: currCategory.categoryBasedPrice,
      availableTimeslots: allTimeSlots,
      ratings: data["rating"],
      ratingsTotal: ratingTotal,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Place &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.distance == distance &&
        other.photoUrl == photoUrl &&
        other.sportCategory == sportCategory &&
        other.priceInCent == priceInCent &&
        listEquals(other.availableTimeslots, availableTimeslots) &&
        other.ratings == ratings &&
        other.ratingsTotal == ratingsTotal;
  }

  // Override hashCode
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        distance.hashCode ^
        photoUrl.hashCode ^
        sportCategory.hashCode ^
        priceInCent.hashCode ^
        availableTimeslots.hashCode ^
        ratings.hashCode ^
        ratingsTotal.hashCode;
  }
}
