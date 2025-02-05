import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<LocationPermission> getPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermission.denied;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return await Geolocator.requestPermission();
    }

    return permission;
  }

  Future<Placemark> getCurrentLocation() async {
    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // You can adjust this as needed
    );

    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks[0];
  }
}
