import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  final GeolocatorPlatform geolocator;
  bool _permissionDenied = false;
  Position? _latLong;
  Placemark? _currentLocation;
  bool _isLoading = false;

  LocationProvider({required this.geolocator});

  bool get permissionDenied => _permissionDenied;
  bool get isLoading => _isLoading;
  Position? get latLong => _latLong;
  Placemark? get currentLocation => _currentLocation;

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      _isLoading = false;
      _permissionDenied = true;
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _permissionDenied = false;
      notifyListeners();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _latLong = position;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      _currentLocation = placemarks.first;
      _isLoading = false;
      notifyListeners();
    }
  }
}
