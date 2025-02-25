import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/reservation.dart';
import '../models/timeslot.dart';

class ReservationProvider extends ChangeNotifier {
  final CollectionReference _reservationCollection;
  late RsStatusList _venueSchedule;
  final StreamController<RsStatusList> _venueScheduleStream =
      StreamController<RsStatusList>.broadcast();
  List<Reservation> _userReservationsList = [];
  List<TimeSlot> _selectedTimeslots = [];

  ReservationProvider(FirebaseFirestore firestore)
      : _reservationCollection = firestore.collection("reservation");

  Stream<RsStatusList> get venueScheduleStream => _venueScheduleStream.stream;
  List<Reservation> get userReservations => _userReservationsList;
  List<TimeSlot> get selectedTimeslots => _selectedTimeslots;

  set selectedTimeslots(List<TimeSlot> timeSlots) {
    _selectedTimeslots = timeSlots;
    notifyListeners();
  }

  void addTimeslot(TimeSlot ts) {
    _selectedTimeslots.add(ts);
    notifyListeners();
  }

  void rmTimeslot(TimeSlot ts) {
    _selectedTimeslots.remove(ts);
    notifyListeners();
  }

  Future<void> createReservation(Reservation rsv) async {
    final rsvRef = _reservationCollection
        .where("venueId", isEqualTo: rsv.venueId)
        .where("profileId", isEqualTo: rsv.profileId)
        .where("reservationDate", isEqualTo: rsv.reservationDate)
        .where("timeSlots", isEqualTo: rsv.getTimeSlotsIdx());

    final snapshot = await rsvRef.get();
    if (snapshot.size > 0) {
      for (var doc in snapshot.docs) {
        if (!doc.exists) {
          continue;
        }

        await doc.reference.update(rsv.toMap());
        _putRsvToSchedule(rsv);
      }
      return;
    }

    await _reservationCollection.add(rsv.toMap());

    _putRsvToSchedule(rsv);
    _venueScheduleStream.add(_venueSchedule);
  }

  Future<void> loadReservationsByVenue(
      DateTime currentDate, String venueId) async {
    _venueSchedule = RsStatusList(currentDate, getDefaultDailySchedule());
    final rsvRef = _reservationCollection
        .where("venueId", isEqualTo: venueId)
        .where(
          "reservationDate",
          isEqualTo:
              DateTime(currentDate.year, currentDate.month, currentDate.day),
        );

    final snapshot = await rsvRef.get();
    if (snapshot.size == 0) {
      _venueScheduleStream.add(_venueSchedule);
      return;
    }

    for (var doc in snapshot.docs) {
      if (!doc.exists) {
        continue;
      }

      final rsv = Reservation.fromMap(doc.data() as Map<String, dynamic>);
      _putRsvToSchedule(rsv);
    }

    _venueScheduleStream.add(_venueSchedule);
  }

  Future<void> loadReservationByUser(String profileId) async {
    final rsvRef = _reservationCollection
        .where("profileId", isEqualTo: profileId)
        .orderBy("reservationDate", descending: true);

    final snapshot = await rsvRef.get();
    if (snapshot.size == 0) {
      _userReservationsList = [];
      return;
    }

    _userReservationsList = snapshot.docs
        .map((doc) => Reservation.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> removeUserReservation(Reservation rsv) async {
    final rsvRef = _reservationCollection
        .where("venueId", isEqualTo: rsv.venueId)
        .where("profileId", isEqualTo: rsv.profileId)
        .where("reservationDate", isEqualTo: rsv.reservationDate)
        .where("timeSlots", isEqualTo: rsv.getTimeSlotsIdx());

    final snapshot = await rsvRef.get();
    if (snapshot.size == 0) {
      return;
    }

    for (var doc in snapshot.docs) {
      if (!doc.exists) {
        continue;
      }
      final rsv = Reservation.fromMap(doc.data() as Map<String, dynamic>);
      await doc.reference.delete();
      _userReservationsList.remove(rsv);
    }
    notifyListeners();
  }

  _putRsvToSchedule(Reservation rsv) {
    for (var ts in rsv.timeSlots) {
      _venueSchedule.reservations[ts.index] =
          ReservationStatus(TimeSlot.values[ts.index], true, details: rsv);
    }
  }
}
