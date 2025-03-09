import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'package:matchpoint/providers/review_provider.dart';
import 'package:matchpoint/widgets/venue_detail_page.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/home_screen.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/providers/location_provider.dart';
import 'package:matchpoint/providers/auth_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/providers/venue_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets(
      'Home screen shows current zip code and list of places based on current location.',
      (WidgetTester tester) async {
    final mockLocProvider = MockLocationProvider();
    final mockAuthProvider = MockAppAuthProvider();
    final mockProfileProvider = MockProfileProvider();
    final mockVenueProvider = MockVenueProvider();

    final locData = LocationData(
        Position(
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
        ),
        Placemark(postalCode: "98122"));
    when(mockLocProvider.locationStream).thenAnswer((_) {
      return Stream.value(locData);
    });
    when(mockLocProvider.currentLocation).thenReturn(locData.placemark);
    when(mockLocProvider.latLong).thenReturn(locData.position);

    final venues = [
      Venue(
        id: "id1",
        name: "the tennis court",
        address: "123 Hey Ho",
        latitude: 48,
        longitude: -122,
        distance: 2,
        photoUrls: [],
        sportCategory: SportsCategories.tennis,
        priceInCent: 30,
        ratings: 8.9,
        ratingsTotal: 12,
      ),
    ];
    when(mockVenueProvider.venueStream).thenAnswer((_) {
      return Stream.value(venues);
    });
    when(mockVenueProvider.getList).thenReturn(venues);
    when(mockVenueProvider.isNextPageLoading).thenReturn(false);

    await mockNetworkImages(
      () async => tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<LocationProvider>.value(
                value: mockLocProvider,
              ),
              Provider<AppAuthProvider>.value(
                value: mockAuthProvider,
              ),
              ChangeNotifierProvider<ProfileProvider>.value(
                value: mockProfileProvider,
              ),
              ChangeNotifierProvider<VenueProvider>.value(
                value: mockVenueProvider,
              ),
            ],
            child: Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      ),
    );

    await mockNetworkImages(() async => tester.pumpAndSettle());

    expect(find.text("98122"), findsOneWidget);
    expect(find.text("the tennis court"), findsOneWidget);
  });

  testWidgets('Tapping card goes to Details Page.',
      (WidgetTester tester) async {
    final mockLocProvider = MockLocationProvider();
    final mockAuthProvider = MockAppAuthProvider();
    final mockProfileProvider = MockProfileProvider();
    final mockVenueProvider = MockVenueProvider();
    final mockReviewProvider = MockReviewProvider();
    final mockRsvProvider = MockReservationProvider();

    final locData = LocationData(
        Position(
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
        ),
        Placemark(postalCode: "98122"));
    when(mockLocProvider.locationStream).thenAnswer((_) {
      return Stream.value(locData);
    });
    when(mockLocProvider.currentLocation).thenReturn(locData.placemark);
    when(mockLocProvider.latLong).thenReturn(locData.position);

    final venues = [
      Venue(
        id: "id1",
        name: "the tennis court",
        address: "123 Hey Ho",
        latitude: 48,
        longitude: -122,
        distance: 2,
        photoUrls: [],
        sportCategory: SportsCategories.tennis,
        priceInCent: 30,
        ratings: 8.9,
        ratingsTotal: 12,
      ),
    ];
    when(mockVenueProvider.venueStream).thenAnswer((_) {
      return Stream.value(venues);
    });
    when(mockVenueProvider.getList).thenReturn(venues);
    when(mockVenueProvider.isNextPageLoading).thenReturn(false);

    await mockNetworkImages(
      () async => tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<LocationProvider>.value(
              value: mockLocProvider,
            ),
            Provider<AppAuthProvider>.value(
              value: mockAuthProvider,
            ),
            ChangeNotifierProvider<ProfileProvider>.value(
              value: mockProfileProvider,
            ),
            ChangeNotifierProvider<VenueProvider>.value(
              value: mockVenueProvider,
            ),
            Provider<ReviewProvider>.value(
              value: mockReviewProvider,
            ),
            ChangeNotifierProvider<ReservationProvider>.value(
              value: mockRsvProvider,
            )
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      ),
    );

    await mockNetworkImages(() async => tester.pumpAndSettle());

    await tester.tap(find.text("the tennis court"));
    await tester.pumpAndSettle();

    expect(find.byType(VenueDetailPage), findsOneWidget);
  });

  testWidgets(
      'Home screen category filter shows the sport name when specific sports category selected',
      (WidgetTester tester) async {
    final mockLocProvider = MockLocationProvider();
    final mockAuthProvider = MockAppAuthProvider();
    final mockProfileProvider = MockProfileProvider();
    final mockVenueProvider = MockVenueProvider();

    final locData = LocationData(
        Position(
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
        ),
        Placemark(postalCode: "98122"));
    when(mockLocProvider.locationStream).thenAnswer((_) {
      return Stream.value(locData);
    });
    when(mockLocProvider.currentLocation).thenReturn(locData.placemark);
    when(mockLocProvider.latLong).thenReturn(locData.position);

    final venues = [
      Venue(
        id: "id1",
        name: "the tennis court",
        address: "123 Hey Ho",
        latitude: 48,
        longitude: -122,
        distance: 2,
        photoUrls: [],
        sportCategory: SportsCategories.tennis,
        priceInCent: 30,
        ratings: 8.9,
        ratingsTotal: 12,
      ),
    ];
    when(mockVenueProvider.venueStream).thenAnswer((_) {
      return Stream.value(venues);
    });
    when(mockVenueProvider.getList).thenReturn(venues);
    when(mockVenueProvider.isNextPageLoading).thenReturn(false);

    await mockNetworkImages(
      () async => tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<LocationProvider>.value(
                value: mockLocProvider,
              ),
              Provider<AppAuthProvider>.value(
                value: mockAuthProvider,
              ),
              ChangeNotifierProvider<ProfileProvider>.value(
                value: mockProfileProvider,
              ),
              ChangeNotifierProvider<VenueProvider>.value(
                value: mockVenueProvider,
              ),
            ],
            child: Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      ),
    );

    await mockNetworkImages(() async => tester.pumpAndSettle());

    expect(find.text("Category"), findsOneWidget);

    await tester.tap(find.text("Category"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Basketball"));
    await tester.pumpAndSettle();

    expect(find.text("Category"), findsNothing);
    expect(find.text("Basketball"), findsOneWidget);
  });
}
