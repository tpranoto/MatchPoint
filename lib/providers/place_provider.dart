import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/place.dart';
import 'package:matchpoint/models/static_data.dart';
import 'package:matchpoint/services/place.dart';

class PlaceProvider extends ChangeNotifier {
  List<Place> _listOfPlaces = [];
  String _nextPageUrl = "";
  bool _isLoading = false;
  bool _isScrollLoading = false;
  String _errorMessage = '';
  String _errorScrollMessage = '';

  List<Place> get getList {
    return [..._listOfPlaces];
  }

  String get nextPageUrl {
    return _nextPageUrl;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get isScrollLoading {
    return _isScrollLoading;
  }

  String get errMsg {
    return _errorMessage;
  }

  String get errScrollMsg {
    return _errorScrollMessage;
  }

  Future<void> fetchPlaces(Position pos, SportsCategories cat,
      {String searchName = ""}) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await PlaceService()
          .fetchNearbyPlaces(pos, cat, searchName: searchName);

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
    if (_isScrollLoading) return;

    _isScrollLoading = true;
    _errorScrollMessage = '';
    notifyListeners();

    try {
      final response =
          await PlaceService().fetchNearbyPlacesNextPage(nextPageUrl);

      if (response["statusCode"] == 200) {
        _listOfPlaces.addAll(response["results"]);
        _nextPageUrl = response["nextPage"];
      } else {
        _errorScrollMessage =
            "${response["statusCode"]}: failed to load places";
      }
    } catch (error) {
      _errorScrollMessage = 'error: $error';
    } finally {
      _isScrollLoading = false;
      notifyListeners();
    }
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
