import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:matchpoint/widgets/home_screen.dart';
import 'package:matchpoint/widgets/main_scaffold.dart';
import 'package:matchpoint/widgets/profile_screen.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/providers/auth_provider.dart';
import 'package:matchpoint/providers/location_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/providers/venue_provider.dart';
// import 'main_scaffold_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationProvider>(),
  MockSpec<AppAuthProvider>(),
  MockSpec<ProfileProvider>(),
  MockSpec<VenueProvider>(),
])
void main() {}