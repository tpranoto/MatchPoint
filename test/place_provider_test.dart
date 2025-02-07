import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/place.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/services/place.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'place_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlaceService>()])
void main() {
  testWidgets(
      "Place Provider fetchPlaces will get data based on position and sports category",
      (WidgetTester tester) async {
    final placeService = MockPlaceService();
    final mockPos = Position(
      longitude: 47,
      latitude: -122,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
    when(placeService.fetchNearbyPlaces(mockPos, SportsCategories.all,
            searchName: ""))
        .thenAnswer((_) async {
      return <String, dynamic>{
        "statusCode": 200,
        "results": [
          Place(
            id: "id1",
            name: "the tennis court",
            address: "123 Hey Ho",
            latitude: 48,
            longitude: -122,
            distance: 2,
            photoUrl: "",
            sportCategory: SportsCategories.tennis,
            priceInCent: 30,
            availableTimeslots: ["9:00"],
            ratings: 8.9,
            ratingsTotal: 12,
          )
        ],
        "nextPage": null,
      };
    });

    final placeProvider = PlaceProvider(placeService: placeService);

    await placeProvider.fetchPlaces(mockPos, SportsCategories.all);

    expect(
        placeProvider.getList,
        equals([
          Place(
            id: "id1",
            name: "the tennis court",
            address: "123 Hey Ho",
            latitude: 48,
            longitude: -122,
            distance: 2,
            photoUrl: "",
            sportCategory: SportsCategories.tennis,
            priceInCent: 30,
            availableTimeslots: ["9:00"],
            ratings: 8.9,
            ratingsTotal: 12,
          )
        ]));
    expect(placeProvider.isLoading, false);
  });
}
