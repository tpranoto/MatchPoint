import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/location_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/services/firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'location_provider_test.mocks.dart';
import 'profile_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GeolocatorPlatform>()])
void main() {

  testWidgets('Should load and save profile correctly', (WidgetTester tester) async {
    final mockGeolocator = MockGeolocatorPlatform();
    final locationProvider = LocationProvider(geolocator: mockGeolocator);


    when(mockGeolocator.checkPermission()).thenAnswer((_) async {
      return LocationPermission.denied;
    });
    when(mockGeolocator.requestPermission()).thenAnswer((_) async {
      return LocationPermission.whileInUse;
    });
    when(mockGeolocator.getCurrentPosition()).thenAnswer((_) async {
      return Position(
          longitude: 25.3241,
          latitude: -14.2364,
          timestamp: DateTime.now(),
          accuracy: 0.0, altitude: 0.0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0
      );
    });

    await locationProvider.getCurrentLocation();
    expect(locationProvider.permissionDenied, isFalse);
    expect(locationProvider.latLong, Position(
        longitude: 25.3241,
        latitude: -14.2364,
        timestamp: DateTime.now(),
        accuracy: 0.0, altitude: 0.0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0
    ));
  });
}