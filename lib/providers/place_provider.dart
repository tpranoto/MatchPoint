import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/place.dart';
import 'package:matchpoint/models/static_data.dart';
import 'package:matchpoint/services/place.dart';

class PlaceProvider extends ChangeNotifier {
  List<Place> _listOfPlaces = [];
  String _nextPageUrl = "";
  bool _isLoading = false;
  String _errorMessage = '';

  List<Place> get getList {
    return [..._listOfPlaces];
  }

  String get nextPageUrl {
    return _nextPageUrl;
  }

  bool get isLoading {
    return _isLoading;
  }

  String get errMsg {
    return _errorMessage;
  }

  Future<void> fetchPlaces(Position pos, SportsCategories cat) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await PlaceService().fetchNearbyPlaces(pos, cat);

      if (response["statusCode"] == 200) {
        _listOfPlaces = response["results"];
        _nextPageUrl = response["nextPage"];
      } else {
        _errorMessage = "${response["statusCode"]}: failed to load places";
      }
    } catch (error) {
      _errorMessage = 'error: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  fetchNextPagePlaces() async {
    PlaceService().fetchNearbyPlacesNextPage(nextPageUrl);
  }

  addList(List<Place> places) {
    _listOfPlaces.addAll(places);
    notifyListeners();
  }

  replaceList(List<Place> places) {
    _listOfPlaces = places;
    notifyListeners();
  }
}
