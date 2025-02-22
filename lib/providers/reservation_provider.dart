import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:matchpoint/models/timeslot.dart';

class ReservationProvider extends ChangeNotifier {
  final CollectionReference _reservationCollection;
  late RsStatusList _venueSchedule;
  final StreamController<RsStatusList> _venueScheduleStream =
      StreamController<RsStatusList>.broadcast();

  List<int> _selectedTimeslots = [];

  ReservationProvider(FirebaseFirestore firestore)
      : _reservationCollection = firestore.collection("reservation");

  Stream<RsStatusList> get venueScheduleStream => _venueScheduleStream.stream;
  List<int> get selectedTimeslots => _selectedTimeslots;

  set selectedTimeslots(List<int> timeSlots) {
    _selectedTimeslots = timeSlots;
    notifyListeners(); // Notify all listeners of the change
  }

  void addTimeslot(int tsIdx) {
    _selectedTimeslots.add(tsIdx);
    notifyListeners();
  }

  void rmTimeslot(int tsIdx) {
    _selectedTimeslots.remove(tsIdx);
    notifyListeners();
  }

  Future<void> createReservation(Reservation rsv) async {
    final rsvRef = _reservationCollection
        .where("venueId", isEqualTo: rsv.venueId)
        .where("profileId", isEqualTo: rsv.profileId)
        .where("reservationDate", isEqualTo: rsv.reservationDate)
        .where("timeSlots", isEqualTo: rsv.timeSlots);

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

  Future<void> removeReservation(Reservation rsv) async {
    final rsvRef = _reservationCollection
        .where("venueId", isEqualTo: rsv.venueId)
        .where("profileId", isEqualTo: rsv.profileId)
        .where("reservationDate", isEqualTo: rsv.reservationDate)
        .where("timeSlots", isEqualTo: rsv.timeSlots);

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
      _rmRsvToSchedule(rsv);
    }
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

  _putRsvToSchedule(Reservation rsv) {
    for (var tsIdx in rsv.timeSlots) {
      _venueSchedule.reservations[tsIdx] =
          ReservationStatus(TimeSlot.values[tsIdx], true, details: rsv);
    }
  }

  _rmRsvToSchedule(Reservation rsv) {
    for (var tsIdx in rsv.timeSlots) {
      _venueSchedule.reservations[tsIdx] =
          ReservationStatus(TimeSlot.values[tsIdx], false, details: null);
    }
  }
}
