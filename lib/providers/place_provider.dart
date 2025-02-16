import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/services/place.dart';

class PlaceProvider extends ChangeNotifier {
  final PlaceService placeService;

  PlaceProvider({required this.placeService});

  List<Venue> _listOfPlaces = [];
  String _nextPageUrl = "";
  bool _isLoading = false;
  bool _isScrollLoading = false;
  String _errorMessage = '';
  String _errorScrollMessage = '';

  List<Venue> get getList {
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
      final response = await placeService.fetchNearbyPlaces(pos, cat,
          searchName: searchName);

      if (response["statusCode"] == 200) {
        _listOfPlaces = response["results"];
        _nextPageUrl = response["nextPage"] ?? "";
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
          await placeService.fetchNearbyPlacesNextPage(nextPageUrl);

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
}
