import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:matchpoint/models/timeslot.dart';
import 'package:matchpoint/models/venue.dart';

void main() {
  test('Create a Reservation object from Map of data.', () {
    final Map<String, dynamic> mockData = {
      "venueId": "vid1",
      "profileId": "pid1",
      "createdAt": Timestamp.fromMillisecondsSinceEpoch(
          DateTime(2025, 02, 25).millisecondsSinceEpoch),
      "reservationDate": Timestamp.fromMillisecondsSinceEpoch(
          DateTime(2025, 02, 28).millisecondsSinceEpoch),
      "timeSlots": [1, 2],
      "venueDetails": {
        "id": "id1",
        "name": "the tennis court",
        "address": "123 Hey Ho",
        "latitude": 48.0,
        "longitude": -122.0,
        "distance": 2.0,
        "photoUrls": [],
        "sportCategory": "Basketball",
        "ratings": 4.4,
        "totalRatings": 3,
      },
    };

    final rsv = Reservation.fromMap(mockData);

    expect(rsv.venueId, equals("vid1"));
    expect(rsv.profileId, equals("pid1"));
    expect(rsv.createdAt, equals(DateTime(2025, 02, 25)));
    expect(rsv.reservationDate, equals(DateTime(2025, 02, 28)));
    expect(rsv.timeSlots, equals([TimeSlot.second, TimeSlot.third]));
    expect(rsv.venueDetails.name, equals("the tennis court"));
  });

  test('Create a Map from Reservation object.', () {
    final mockRsv = Reservation(
      venueId: "vid1",
      profileId: "pid1",
      createdAt: DateTime(2025, 02, 25),
      reservationDate: DateTime(2025, 02, 28),
      timeSlots: [TimeSlot.second],
      venueDetails: Venue(
        id: "id1",
        name: "the tennis court",
        address: "123 Hey Ho",
        latitude: 48,
        longitude: -122,
        distance: 2,
        photoUrls: [],
        sportCategory: SportsCategories.basketball,
        priceInCent: 30,
        ratings: 4.4,
        ratingsTotal: 12,
      ),
    );

    final data = mockRsv.toMap();

    expect(data["venueId"], equals("vid1"));
    expect(data["profileId"], equals("pid1"));
    expect(data["createdAt"], equals(DateTime(2025, 02, 25)));
    expect(data["reservationDate"], equals(DateTime(2025, 02, 28)));
    expect(data["timeSlots"], equals([1]));
    expect(
        data["venueDetails"],
        equals({
          "id": "id1",
          "name": "the tennis court",
          "address": "123 Hey Ho",
          "latitude": 48.0,
          "longitude": -122.0,
          "distance": 2.0,
          "photoUrls": [],
          "sportCategory": "Basketball",
          "priceInCent": 30,
          "ratings": 4.4,
          "ratingsTotal": 12,
        }));
  });

  test('Get indexes of timeslots from list of timeslots.', () {
    final mockRsv = Reservation(
      venueId: "vid1",
      profileId: "pid1",
      createdAt: DateTime(2025, 02, 25),
      reservationDate: DateTime(2025, 02, 28),
      timeSlots: [TimeSlot.second, TimeSlot.third],
      venueDetails: Venue(
        id: "id1",
        name: "the tennis court",
        address: "123 Hey Ho",
        latitude: 48,
        longitude: -122,
        distance: 2,
        photoUrls: [],
        sportCategory: SportsCategories.basketball,
        priceInCent: 30,
        ratings: 4.4,
        ratingsTotal: 12,
      ),
    );

    final idxs = mockRsv.getTimeSlotsIdx();

    expect(idxs[0], equals(1));
    expect(idxs[1], equals(2));
  });
}
