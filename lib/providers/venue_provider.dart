import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:matchpoint/models/places.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/models/category.dart';

class VenueProvider extends ChangeNotifier {
  final String apiKey;
  List<Venue> _listOfVenues = [];
  String _nextPageUrl = "";

  bool _isLoading = false;
  bool _isNextPageLoading = false;

  VenueProvider(this.apiKey);

  List<Venue> get getList => [..._listOfVenues];

  String get nextPageUrl => _nextPageUrl;

  bool get isLoading => _isLoading;
  bool get isNextPageLoading => _isNextPageLoading;

  Future<void> fetchVenues(
    Position pos,
    SportsCategories cat, {
    String searchName = "",
    int radius = 20000,
    int limit = 20,
  }) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final url = _setUpPlacesUrl(pos, cat, searchName, radius, limit);

      final headers = {
        "Authorization": apiKey,
        "accept": "application/json",
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      final parsedResp = Places.fromResponse(response);
      if (parsedResp.statusCode != 200) {
        throw Exception('error response status code: ${parsedResp.statusCode}');
      }
      _listOfVenues = parsedResp.venues;
      _nextPageUrl = parsedResp.nextPage ?? "";
    } catch (e) {
      throw Exception('error response status code: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  fetchNextPageVenues() async {
    if (_isNextPageLoading) return;

    _isNextPageLoading = true;
    notifyListeners();

    final headers = {
      "Authorization": apiKey,
      "accept": "application/json",
    };
    try {
      final response =
          await http.get(Uri.parse(_nextPageUrl), headers: headers);
      final parsedResp = Places.fromResponse(response);
      if (parsedResp.statusCode != 200) {
        throw Exception('error response status code: ${parsedResp.statusCode}');
      }
      _listOfVenues.addAll(parsedResp.venues);
      _nextPageUrl = parsedResp.nextPage ?? "";
    } catch (e) {
      throw Exception('error response status code: ${e.toString()}');
    } finally {
      _isNextPageLoading = false;
      notifyListeners();
    }
  }

  String _setUpPlacesUrl(Position curPos, SportsCategories cat,
      String? searchName, int radius, int limit) {
    String placesUrl =
        "https://api.foursquare.com/v3/places/search?radius=$radius&categories=${cat.category4SCode}";

    if (searchName != null && searchName != "") {
      placesUrl = "$placesUrl&query=$searchName";
    }

    placesUrl =
        "$placesUrl&fields=fsq_id,categories,distance,geocodes,location,name,description,rating,photos,stats,price";

    placesUrl = "$placesUrl&sort=DISTANCE&limit=$limit";
    placesUrl = "$placesUrl&ll=${curPos.latitude},${curPos.longitude}";

    return placesUrl;
  }
}
