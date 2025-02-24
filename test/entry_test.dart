// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:matchpoint/widgets/entry.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mocktail_image_network/mocktail_image_network.dart';
// import 'package:provider/provider.dart';
// import 'package:matchpoint/widgets/login_page.dart';
// import 'package:matchpoint/widgets/main_scaffold.dart';
// import 'package:matchpoint/models/auth.dart';
// import 'package:matchpoint/models/category.dart';
// import 'package:matchpoint/models/venue.dart';
// import 'package:matchpoint/providers/auth_provider.dart';
// import 'package:matchpoint/providers/location_provider.dart';
// import 'package:matchpoint/providers/profile_provider.dart';
// import 'package:matchpoint/providers/venue_provider.dart';
// import 'main_scaffold_test.mocks.dart';
//
// void main() {
//   testWidgets('Entry go to Login Page if user is not authenticated.',
//       (WidgetTester tester) async {
//     final mockAuthProvider = MockAppAuthProvider();
//     final mockProfileProvider = MockProfileProvider();
//
//     when(mockAuthProvider.stateChanges)
//         .thenAnswer((_) => Stream.fromIterable([]));
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: MultiProvider(
//           providers: [
//             Provider<AppAuthProvider>.value(
//               value: mockAuthProvider,
//             ),
//             ChangeNotifierProvider<ProfileProvider>.value(
//               value: mockProfileProvider,
//             ),
//           ],
//           child: Entry(),
//         ),
//       ),
//     );
//     await mockNetworkImages(() async => tester.pumpAndSettle());
//
//     expect(find.text("Sign in with Google"), findsOneWidget);
//   });
//
//   testWidgets('Entry go into MainScaffold if user is authenticated.',
//       (WidgetTester tester) async {
//     final mockLocProvider = MockLocationProvider();
//     final mockAuthProvider = MockAppAuthProvider();
//     final mockProfileProvider = MockProfileProvider();
//     final mockVenueProvider = MockVenueProvider();
//
//     when(mockAuthProvider.stateChanges).thenAnswer((_) => Stream.value(
//         Auth("id1", "email1@gmail.com", "Hey Ho", "http://my-profile-pic")));
//
//     final locData = LocationData(
//         Position(
//           latitude: 47.6062,
//           longitude: -122.3321,
//           timestamp: DateTime.now(),
//           accuracy: 5.0,
//           altitude: 0.0,
//           altitudeAccuracy: 0.0,
//           heading: 0.0,
//           headingAccuracy: 0.0,
//           speed: 0.0,
//           speedAccuracy: 0.0,
//         ),
//         Placemark(postalCode: "33221"));
//     when(mockLocProvider.locationStream).thenAnswer((_) {
//       return Stream.value(locData);
//     });
//     when(mockLocProvider.currentLocation).thenReturn(locData.placemark);
//     when(mockLocProvider.latLong).thenReturn(locData.position);
//
//     final venues = [
//       Venue(
//         id: "id1",
//         name: "the tennis court",
//         address: "123 Hey Ho",
//         latitude: 48,
//         longitude: -122,
//         distance: 2,
//         photoUrl: "",
//         sportCategory: SportsCategories.tennis,
//         priceInCent: 30,
//         ratings: 8.9,
//         ratingsTotal: 12,
//       ),
//     ];
//     when(mockVenueProvider.venueStream).thenAnswer((_) {
//       return Stream.value(venues);
//     });
//     when(mockVenueProvider.getList).thenReturn(venues);
//     when(mockVenueProvider.isNextPageLoading).thenReturn(false);
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: MultiProvider(
//           providers: [
//             Provider<LocationProvider>.value(
//               value: mockLocProvider,
//             ),
//             Provider<AppAuthProvider>.value(
//               value: mockAuthProvider,
//             ),
//             ChangeNotifierProvider<ProfileProvider>.value(
//               value: mockProfileProvider,
//             ),
//             ChangeNotifierProvider<VenueProvider>.value(
//               value: mockVenueProvider,
//             ),
//           ],
//           child: Entry(),
//         ),
//       ),
//     );
//
//     await mockNetworkImages(() async => tester.pumpAndSettle());
//
//     expect(find.byType(MainScaffold), findsOneWidget);
//   });
// }
