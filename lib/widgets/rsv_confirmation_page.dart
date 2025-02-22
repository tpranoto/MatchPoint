import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/models/timeslot.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'main_scaffold.dart';
import 'simple_venue_detail.dart';
import '../models/reservation.dart';
import '../models/venue.dart';
import '../providers/profile_provider.dart';
import '../providers/reservation_provider.dart';

class RsvConfirmationPage extends StatelessWidget {
  final Venue venue;
  final DateTime selectedDate;

  const RsvConfirmationPage(this.venue, this.selectedDate, {super.key});

  @override
  Widget build(BuildContext context) {
    final rsvProvider = context.watch<ReservationProvider>();
    final profileProvider = context.read<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Confirmation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SimpleVenueDetail(venue),
          Column(
            children: [
              CenteredTitle("Booked Schedule"),
              Text(DateFormat('EEEE, dd MMM yyyy').format(selectedDate)),
              ...(rsvProvider.selectedTimeslots
                    ..sort((a, b) => TimeSlot.values[a].time
                        .compareTo(TimeSlot.values[b].time)))
                  .map((item) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(TimeSlot.values[item].showTimeRange),
                    Text("${venue.priceInCent / 100}")
                  ],
                );
              }),
              CenteredTitle("Payment Details"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total cost"),
                  Text(
                      "${venue.priceInCent * rsvProvider.selectedTimeslots.length / 100}")
                ],
              ),
            ],
          ),
          SquaredButton(
              text: "Confirm",
              bg: Theme.of(context).colorScheme.primary,
              fg: Theme.of(context).colorScheme.onPrimary,
              onPressed: () async {
                await rsvProvider.createReservation(Reservation(
                  venueId: venue.id,
                  profileId: profileProvider.getProfile.id,
                  createdAt: DateTime.now(),
                  reservationDate: DateTime(
                      selectedDate.year, selectedDate.month, selectedDate.day),
                  timeSlots: rsvProvider.selectedTimeslots,
                ));

                await profileProvider.incrReservations();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) => MainScaffold(
                              startIndex: 1,
                            )),
                    (Route<dynamic> route) => false);
              },
              icon: SizedBox.shrink()),
        ],
      ),
    );
  }
}
