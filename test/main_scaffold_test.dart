import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/location_provider.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/home_screen.dart';
import 'package:matchpoint/widgets/main_scaffold.dart';
import 'package:matchpoint/widgets/profile_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'home_screen_test.mocks.dart';
import "profile_screen_test.mocks.dart";

void main() {
  testWidgets(
      'Main Scaffold will redirect to Login Screen from Home Screen when Account navigation tab clicked',
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
      Venue(
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

    final mockAuthService = MockAuthService();

    final mockProfile = Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    );
    final mockProfileProv = MockAppProfileProvider();
    when(mockProfileProv.getData).thenReturn(mockProfile);

    await mockNetworkImages(
      () async => tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<AuthService>.value(
                value: mockAuthService,
              ),
              ChangeNotifierProvider<AppProfileProvider>.value(
                value: mockProfileProv,
              ),
              ChangeNotifierProvider<LocationProvider>.value(
                value: mockLocProvider,
              ),
              ChangeNotifierProvider<PlaceProvider>.value(
                value: mockPlaceProvider,
              ),
            ],
            child: MainScaffold(),
          ),
        ),
      ),
    );

    // starts from home screen
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.text("Account"));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
