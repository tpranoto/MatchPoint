import 'category.dart';

class Venue {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final List<String>? photoUrls;
  final SportsCategories sportCategory;
  final int priceInCent;
  final double? ratings;
  final int? ratingsTotal;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.photoUrls,
    required this.sportCategory,
    required this.priceInCent,
    required this.ratings,
    required this.ratingsTotal,
  });

  factory Venue.fromResponse(Map<String, dynamic> data) {
    final mainGeocodes = data["geocodes"]["main"];
    final List<dynamic> photos = data["photos"];
    List<String>? photoUrl = photos.isNotEmpty
        ? photos
            .map((photo) => "${photo["prefix"]}original${photo["suffix"]}")
            .toList()
        : null;

    final List<dynamic> categories = data["categories"];
    final currCategory = categoryEnum(categories[0]["name"]);
    final double metersInOneMile = 1609.344;

    int? ratingTotal = 0;
    if (data["stats"] != null) {
      ratingTotal = data["stats"]["total_ratings"];
    }

    return Venue(
      id: data["fsq_id"],
      name: data["name"],
      address: data["location"]["formatted_address"],
      latitude: mainGeocodes["latitude"],
      longitude: mainGeocodes["longitude"],
      distance: data["distance"] / metersInOneMile,
      photoUrls: photoUrl,
      sportCategory: currCategory,
      priceInCent: currCategory.categoryBasedPrice,
      ratings: data["rating"]!=null?data["rating"]/2:data["rating"],
      ratingsTotal: ratingTotal,
    );
  }

  factory Venue.fromMap(Map<String, dynamic> data) {
    final currCategory = categoryEnum(data["sportCategory"]);

    return Venue(
      id: data["id"],
      name: data["name"],
      address: data["address"],
      latitude: data["latitude"],
      longitude: data["longitude"],
      distance: data["distance"],
      photoUrls: (data["photoUrls"] as List).map((e) => e as String).toList(),
      sportCategory: currCategory,
      priceInCent: currCategory.categoryBasedPrice,
      ratings: data["ratings"],
      ratingsTotal: data["totalRatings"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "distance": distance,
      "photoUrls": photoUrls,
      "sportCategory": sportCategory.categoryString,
      "priceInCent": priceInCent,
      "ratings": ratings,
      "ratingsTotal": ratingsTotal,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Venue &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.distance == distance &&
        other.photoUrls == photoUrls &&
        other.sportCategory == sportCategory &&
        other.priceInCent == priceInCent &&
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
        photoUrls.hashCode ^
        sportCategory.hashCode ^
        priceInCent.hashCode ^
        ratings.hashCode ^
        ratingsTotal.hashCode;
  }
}
