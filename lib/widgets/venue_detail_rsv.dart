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
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservationProvider>().selectedTimeslots = [];
      context.read<ReservationProvider>().loadReservationsByVenue(selectedDate, widget.venue.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rsvProvider = context.watch<ReservationProvider>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(spacing: 10,
            children: [
              CenteredTitle("Make a Reservation", size: 18),
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(12),
                ),
                child: EasyDateTimeLinePicker(
                  focusedDate: selectedDate,
                  timelineOptions: const TimelineOptions(height: 80),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 6)),
                  headerOptions: const HeaderOptions(headerType: HeaderType.none),
                  onDateChange: (date) async {
                    setState(() {
                      selectedDate = date;
                      rsvProvider.selectedTimeslots = [];
                    });
                    await rsvProvider.loadReservationsByVenue(selectedDate, widget.venue.id);
                  },
                ),
              ),
              CenteredTitle("Available Timeslots", size: 18),
              VenueDetailTimeslot(selectedDate: selectedDate),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity,
                child: ElevatedButton(
                  onPressed: rsvProvider.selectedTimeslots.isEmpty ? null : () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RsvConfirmationPage(widget.venue, selectedDate),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Reserve ${rsvProvider.selectedTimeslots.length} slots",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
