import 'package:matchpoint/models/static_data.dart';

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
  final double ratings;
  final int ratingsTotal;

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
    final List<Map<String, dynamic>> photos = data["photos"];
    String photoUrl = "";
    if (photos.isNotEmpty) {
      photoUrl = "${photos[0]["prefix"]}original${photos[0]["suffix"]}";
    }

    final List<Map<String, dynamic>> categories = data["categories"];
    final currCategory = categoryEnum(categories[0]["name"]);
    final double metersInOneMile = 1609.344;

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
      ratingsTotal: data["stats"]["total_ratings"],
    );
  }
}
