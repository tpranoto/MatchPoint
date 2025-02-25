import 'dart:convert';
import 'package:http/http.dart' as http;
import 'venue.dart';

class Places {
  int statusCode;
  List<Venue> venues = [];
  String? nextPage;

  Places({required this.statusCode, required this.venues, this.nextPage});

  factory Places.fromResponse(http.Response resp) {
    List<Venue> venues = [];
    String? nextPage;
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      List<dynamic> list = data["results"];
      for (var item in list) {
        venues.add(Venue.fromResponse(item));
      }

      final linkHeader = resp.headers['link'];
      if (linkHeader != null && linkHeader.contains('rel="next"')) {
        final regExp = RegExp(r'<(.*?)>; rel="next"');
        final match = regExp.firstMatch(linkHeader);
        if (match != null) {
          nextPage = match.group(1);
        }
      }
    }
    return Places(
        statusCode: resp.statusCode, venues: venues, nextPage: nextPage);
  }
}
