import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  final GeolocatorPlatform geolocator;
  bool _permissionDenied = false;
  late Position _latLong;
  late Placemark _currentLocation;

  bool _isLoading = false;

  LocationProvider(this.geolocator);

  bool get permissionDenied => _permissionDenied;
  Position get latLong => _latLong;
  Placemark get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;

  Future<void> loadCurrentLocation() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    LocationPermission permission = await geolocator.checkPermission();

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      permission = await geolocator.requestPermission();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      _permissionDenied = true;
      _isLoading = false;
      notifyListeners();
      return;
    }
    _permissionDenied = false;

    _latLong = await geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latLong.latitude, _latLong.longitude);
    _currentLocation = placemarks.first;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCurrentLocationNew() async {
    LocationPermission permission = await geolocator.checkPermission();

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      permission = await geolocator.requestPermission();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      _permissionDenied = true;
      return;
    }

    _latLong = await geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latLong.latitude, _latLong.longitude);
    _currentLocation = placemarks.first;
  }
}
