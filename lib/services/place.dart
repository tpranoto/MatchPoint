import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:matchpoint/models/static_data.dart';

import '../models/place.dart';

class PlaceService {
  final String _apiKey = dotenv.env["SQUARESPACE_API_KEY"] ?? "";

  Future<Map<String, dynamic>> fetchNearbyPlaces(
      Position pos, SportsCategories cat,
      {String? searchName, int radius = 20000, int limit = 20}) async {
    String url = _setUpPlacesUrl(pos, cat, searchName, radius, limit);

    final headers = {
      "Authorization": _apiKey,
      "accept": "application/json",
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> fetchNearbyPlacesNextPage(
      String nextPageUrl) async {
    final headers = {
      "Authorization": _apiKey,
      "accept": "application/json",
    };
    final response = await http.get(Uri.parse(nextPageUrl), headers: headers);

    return _handleResponse(response);
  }

  _setUpPlacesUrl(Position curPos, SportsCategories cat, String? searchName,
      int radius, int limit) {
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

  String? _extractNextPageUrl(String linkHeader) {
    final regExp = RegExp(r'<(.*?)>; rel="next"');
    final match = regExp.firstMatch(linkHeader);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  Map<String, dynamic> _handleResponse(http.Response resp) {
    Map<String, dynamic> result = {};
    result["statusCode"] = resp.statusCode;
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      List<dynamic> list = data["results"];
      List<Place> places = [];
      for (var currItem in list) {
        places.add(Place.fromResponse(currItem));
      }
      result["results"] = places;

      final linkHeader = resp.headers['link'];
      if (linkHeader != null && linkHeader.contains('rel="next"')) {
        final nextLink = _extractNextPageUrl(linkHeader);
        result["nextPage"] = nextLink;
      }
    }

    return result;
  }
}
