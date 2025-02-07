import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/place.dart';
import 'package:matchpoint/providers/location_provider.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/widgets/home_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'home_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationProvider>(), MockSpec<PlaceProvider>()])
void main() {
  testWidgets(
      'Home screen shows current zip code and list of places based on current location.',
      (WidgetTester tester) async {
    final mockLocProvider = MockLocationProvider();
    when(mockLocProvider.latLong).thenReturn(Position(
      latitude: 47.6062,
      longitude: -122.3321,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    ));
    when(mockLocProvider.currentLocation).thenReturn(Placemark(
      postalCode: "98122",
    ));
    when(mockLocProvider.isLoading).thenReturn(false);
    final mockPlaceProvider = MockPlaceProvider();
    when(mockPlaceProvider.isLoading).thenReturn(false);
    when(mockPlaceProvider.getList).thenReturn([
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
      ),
    ]);
    await mockNetworkImages(
      () async => tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<LocationProvider>.value(
                value: mockLocProvider,
              ),
              ChangeNotifierProvider<PlaceProvider>.value(
                value: mockPlaceProvider,
              ),
            ],
            child: Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      ),
    );
    expect(find.text("98122"), findsOneWidget);
    expect(find.text("the tennis court"), findsOneWidget);
  });
}
