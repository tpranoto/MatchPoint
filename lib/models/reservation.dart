import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchpoint/models/timeslot.dart';

class Reservation {
  final String venueId;
  final String venueName;
  final String profileId;
  final DateTime createdAt;
  final DateTime reservationDate;
  final List<int> timeSlots; //use TimeSlots ENUM index

  Reservation(
      {required this.venueId,
        required this.venueName,
      required this.profileId,
      required this.createdAt,
      required this.reservationDate,
      required this.timeSlots});

  factory Reservation.fromMap(Map<String, dynamic> data) {
    return Reservation(
      venueId: data['venueId'],
      venueName: data.containsKey('venueName') ? data['venueName'] : "Unknown Venue",
      profileId: data['profileId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      reservationDate: (data['reservationDate'] as Timestamp).toDate(),
      timeSlots: (data['timeSlots'] as List).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "venueId": venueId,
      "profileId": profileId,
      "reservationDate": reservationDate,
      "createdAt": createdAt,
      "timeSlots": timeSlots,
    };
  }
  Reservation copyWith({String? venueName}) {
    return Reservation(
      venueId: venueId,
      venueName: venueName ?? this.venueName,
      profileId: profileId,
      createdAt: createdAt,
      reservationDate: reservationDate,
      timeSlots: timeSlots,
    );
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
