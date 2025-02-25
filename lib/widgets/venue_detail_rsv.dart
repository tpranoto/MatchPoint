import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rsv_confirmation_page.dart';
import 'venue_detail_timeslot.dart';
import 'common.dart';
import '../models/venue.dart';
import '../providers/reservation_provider.dart';

class VenueDetailRsv extends StatefulWidget {
  final Venue venue;

  const VenueDetailRsv(this.venue, {super.key});

  @override
  State<VenueDetailRsv> createState() => _VenueDetailRsvState();
}

class _VenueDetailRsvState extends State<VenueDetailRsv> {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservationProvider>().selectedTimeslots = [];
      context
          .read<ReservationProvider>()
          .loadReservationsByVenue(selectedDate, widget.venue.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rsvProvider = context.watch<ReservationProvider>();

    return Column(
      spacing: 10,
      children: [
        CenteredTitle("Make a reservation", size: 16),
        EasyDateTimeLinePicker(
          focusedDate: selectedDate,
          timelineOptions: TimelineOptions(height: 80),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 6)),
          headerOptions: HeaderOptions(headerType: HeaderType.none),
          onDateChange: (date) async {
            setState(() {
              selectedDate = date;
              rsvProvider.selectedTimeslots = [];
            });
            await rsvProvider.loadReservationsByVenue(
                selectedDate, widget.venue.id);
          },
        ),
        CenteredTitle("Available timeslots", size: 16),
        VenueDetailTimeslot(selectedDate: selectedDate),
        SquaredButton(
          text: "Reserve ${rsvProvider.selectedTimeslots.length} slots",
          bg: Theme.of(context).colorScheme.primary,
          fg: Theme.of(context).colorScheme.onPrimary,
          onPressed: rsvProvider.selectedTimeslots.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          RsvConfirmationPage(widget.venue, selectedDate),
                    ),
                  );
                },
        ),
      ],
    );
  }
}
