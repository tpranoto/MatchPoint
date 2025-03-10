import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  _onConfirmPress(BuildContext context) async {
    final rsvProvider = context.read<ReservationProvider>();
    final profileProvider = context.read<ProfileProvider>();

    await context.read<ReservationProvider>().createReservation(Reservation(
          venueId: venue.id,
          profileId: profileProvider.getProfile.id,
          createdAt: DateTime.now(),
          reservationDate:
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
          timeSlots: rsvProvider.selectedTimeslots,
          venueDetails: venue,
        ));

    await profileProvider.incrReservations();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (ctx) => MainScaffold(
                  startIndex: 1,
                )),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.indigo.shade100,
        title: Text(
          "Confirmation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        spacing: 10,
        children: [
          SimpleVenueDetail(venue),
          _PaymentSummary(venue, selectedDate),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SquaredButton(
                text: "  Edit  ",
                bg: Theme.of(context).colorScheme.surfaceContainerLowest,
                fg: Theme.of(context).colorScheme.onSurfaceVariant,
                onPressed: () async => Navigator.of(context).pop(),
                size: Size(150, 50),
              ),
              SquaredButton(
                text: "Confirm",
                bg: Theme.of(context).colorScheme.primary,
                fg: Theme.of(context).colorScheme.onPrimary,
                onPressed: () async => _onConfirmPress(context),
                size: Size(150, 50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  final Venue venue;
  final DateTime selectedDate;

  const _PaymentSummary(this.venue, this.selectedDate);

  @override
  Widget build(BuildContext context) {
    final rsvProvider = context.watch<ReservationProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Payment Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(color: Colors.black, thickness: 2.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat('EEEE, dd MMM yyyy').format(selectedDate),
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 5),
          ...(rsvProvider.selectedTimeslots
                ..sort((a, b) => a.time.compareTo(b.time)))
              .map((item) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.showTimeRange),
                Text("\$ ${venue.priceInCent / 100}")
              ],
            );
          }),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total cost",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                "\$ ${venue.priceInCent * rsvProvider.selectedTimeslots.length / 100}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
