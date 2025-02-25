import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationData {
  final Position position;
  final Placemark placemark;

  LocationData(this.position, this.placemark);
}

class LocationProvider {
  final GeolocatorPlatform geolocator;
  bool _permissionDenied = false;
  late Position _latLong;
  Placemark? _currentLocation;
  final StreamController<LocationData> _locStream =
      StreamController<LocationData>.broadcast();

  LocationProvider(this.geolocator);

  bool get permissionDenied => _permissionDenied;
  Position get latLong => _latLong;
  Placemark? get currentLocation => _currentLocation;
  Stream<LocationData> get locationStream => _locStream.stream;

  void streamCurrentLocation() {
    if (_currentLocation != null) {
      _locStream.add(LocationData(_latLong, _currentLocation!));
    }
  }

  Future<void> loadCurrentLocation() async {
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
    _permissionDenied = false;

    _latLong = await geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latLong.latitude, _latLong.longitude);
    _currentLocation = placemarks.first;

    _locStream.add(LocationData(_latLong, _currentLocation!));
  }
}
