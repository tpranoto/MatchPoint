import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchpoint/models/timeslot.dart';
import 'package:matchpoint/models/venue.dart';

class Reservation {
  String? rsvId;
  final String venueId;
  final String profileId;
  final DateTime createdAt;
  final DateTime reservationDate;
  final List<TimeSlot> timeSlots;
  final Venue venueDetails;
  bool? reviewed;

  Reservation({
    required this.venueId,
    required this.profileId,
    required this.createdAt,
    required this.reservationDate,
    required this.timeSlots,
    required this.venueDetails,
    this.reviewed,
    this.rsvId,
  });

  factory Reservation.fromMap(Map<String, dynamic> data, {String? rsvId}) {
    Reservation rsv = Reservation(
      venueId: data['venueId'],
      profileId: data['profileId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      reservationDate: (data['reservationDate'] as Timestamp).toDate(),
      timeSlots: (data['timeSlots'] as List)
          .map((idx) => TimeSlot.values[idx])
          .toList(),
      venueDetails: Venue.fromMap(data["venueDetails"]),
      reviewed: data['reviewed'],
    );

    if (rsvId != null) {
      rsv.rsvId = rsvId;
    }

    return rsv;
  }

  Map<String, dynamic> toMap() {
    return {
      "venueId": venueId,
      "profileId": profileId,
      "reservationDate": reservationDate,
      "createdAt": createdAt,
      "timeSlots": timeSlots.map((item) => item.index).toList(),
      "venueDetails": venueDetails.toMap(),
      "reviewed": reviewed,
    };
  }

  List<int> getTimeSlotsIdx() {
    return timeSlots.map((element) => element.index).toList();
  }

  bool rsvPassed() {
    for (var ts in timeSlots) {
      DateTime rsvDate = reservationDate;
      if (rsvDate.add(ts.time).isBefore(DateTime.now())) {
        return true;
      }
    }

    return false;
  }
}

class ReservationStatus {
  final TimeSlot timeSlot;
  final bool reserved;
  Reservation? details;

  ReservationStatus(this.timeSlot, this.reserved, {this.details});
}

class RsStatusList {
  final DateTime date;
  final List<ReservationStatus> reservations;

  RsStatusList(this.date, this.reservations);
}

List<ReservationStatus> getDefaultDailySchedule() {
  return [
    ReservationStatus(TimeSlot.first, false),
    ReservationStatus(TimeSlot.second, false),
    ReservationStatus(TimeSlot.third, false),
    ReservationStatus(TimeSlot.fourth, false),
    ReservationStatus(TimeSlot.fifth, false),
    ReservationStatus(TimeSlot.sixth, false),
    ReservationStatus(TimeSlot.seventh, false),
    ReservationStatus(TimeSlot.eighth, false),
    ReservationStatus(TimeSlot.ninth, false),
    ReservationStatus(TimeSlot.tenth, false),
    ReservationStatus(TimeSlot.eleventh, false),
    ReservationStatus(TimeSlot.twelfth, false),
    ReservationStatus(TimeSlot.thirteenth, false),
    ReservationStatus(TimeSlot.fourteenth, false),
  ];
}
