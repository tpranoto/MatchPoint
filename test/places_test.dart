import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matchpoint/models/places.dart';

void main() {
  test('create Places object based on http response', () {
    final results =
        '[{"fsq_id": "fsq_id1","name": "this_is_da_name","location": {"formatted_address": "this_is_da_street"},"geocodes": {"main": {"latitude": 42.0,"longitude": -122.0}},"distance": 1609.344,"photos": [],"categories": []}]';

    final jsonResponse = '{"results": $results}';

    final resp = http.Response(jsonResponse, 200,
        headers: {"link": '<http://next_page>; rel="next"'});

    final places = Places.fromResponse(resp);

    expect(places.statusCode, equals(200));
    expect(places.venues[0].name, equals("this_is_da_name"));
    expect(places.nextPage, equals("http://next_page"));
  });
}
