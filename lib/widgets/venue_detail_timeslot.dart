import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import '../models/timeslot.dart';
import '../providers/reservation_provider.dart';

class VenueDetailTimeslot extends StatefulWidget {
  final DateTime selectedDate;
  const VenueDetailTimeslot({super.key, required this.selectedDate});

  @override
  State<VenueDetailTimeslot> createState() => _VenueDetailTimeslotState();
}

class _VenueDetailTimeslotState extends State<VenueDetailTimeslot> {
  _onTimeSlotClick(TimeSlot ts) {
    final rsvProvider = context.read<ReservationProvider>();
    setState(() {
      if (rsvProvider.selectedTimeslots.contains(ts)) {
        rsvProvider.rmTimeslot(ts);
      } else {
        rsvProvider.addTimeslot(ts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rsvProvider = context.watch<ReservationProvider>();

    return MPStreamBuilder(
      stream: rsvProvider.venueScheduleStream,
      streamContinuation: () {},
      onSuccess: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        return SizedBox(
          height: 50,
          child: Align(
            alignment: Alignment.topLeft,
            child: widget.selectedDate
                    .add(snapshot.data!.reservations.last.timeSlot.time)
                    .isBefore(DateTime.now())
                ? Center(child: Text("No available timeslot"))
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.reservations.length,
                    itemBuilder: (context, index) {
                      final timeSlot =
                          snapshot.data!.reservations[index].timeSlot;

                      return widget.selectedDate
                              .add(timeSlot.time)
                              .isBefore(DateTime.now())
                          ? SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: SquaredButton(
                                text: timeSlot.toString(),
                                onPressed:
                                    snapshot.data!.reservations[index].reserved
                                        ? null
                                        : () {
                                            _onTimeSlotClick(
                                                TimeSlot.values[index]);
                                          },
                                bg: rsvProvider.selectedTimeslots
                                        .contains(TimeSlot.values[index])
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                fg: rsvProvider.selectedTimeslots
                                        .contains(TimeSlot.values[index])
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                              ),
                            );
                    }),
          ),
        );
      },
    );
  }
}
