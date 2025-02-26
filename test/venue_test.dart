import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/venue.dart';

void main() {
  test('create Venue object based on map data', () {
    final Map<String, dynamic> mockData = {
      "id": "id1",
      "name": "the tennis court",
      "address": "123 Hey Ho",
      "latitude": 48.0,
      "longitude": -122.0,
      "distance": 2.0,
      "photoUrls": [],
      "sportCategory": "Basketball",
      "ratings": 4.4,
      "totalRatings": 3,
    };

    final venue = Venue.fromMap(mockData);

    expect(venue.id, equals("id1"));
    expect(venue.name, equals("the tennis court"));
    expect(venue.address, equals("123 Hey Ho"));
    expect(venue.latitude, equals(48.0));
    expect(venue.longitude, equals(-122.0));
    expect(venue.distance, equals(2.0));
    expect(venue.photoUrls, equals([]));
    expect(venue.sportCategory, equals(SportsCategories.basketball));
    expect(venue.ratings, equals(4.4));
    expect(venue.ratingsTotal, equals(3));
  });

  test('create Map based on Venue object', () {
    final venue = Venue(
      id: "id1",
      name: "the tennis court",
      address: "123 Hey Ho",
      latitude: 48,
      longitude: -122,
      distance: 2,
      photoUrls: [],
      sportCategory: SportsCategories.tennis,
      priceInCent: 30,
      ratings: 3.9,
      ratingsTotal: 12,
    );

    final venueMap = venue.toMap();

    expect(venueMap["id"], equals("id1"));
    expect(venueMap["name"], equals("the tennis court"));
    expect(venueMap["address"], equals("123 Hey Ho"));
    expect(venueMap["latitude"], equals(48.0));
    expect(venueMap["longitude"], equals(-122.0));
    expect(venueMap["distance"], equals(2.0));
    expect(venueMap["photoUrls"], equals([]));
    expect(venueMap["sportCategory"], equals("Tennis"));
    expect(venueMap["ratings"], equals(3.9));
    expect(venueMap["ratingsTotal"], equals(12));
  });
}
