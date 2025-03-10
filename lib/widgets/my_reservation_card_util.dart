import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'review_input_dialog.dart';
import 'common.dart';
import '../models/category.dart';
import '../models/reservation.dart';
import '../providers/profile_provider.dart';
import '../providers/reservation_provider.dart';

class MyRsvDetails extends StatelessWidget {
  final Reservation rsv;
  const MyRsvDetails(this.rsv, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: IconWithText(
                icon: Icons.calendar_today,
                text: rsv.reservationDate.toLocal().toString().split(' ')[0],
                size: 14,
              ),
            ),
            Flexible(
              child: IconWithText(
                icon: Icons.sports_soccer_outlined,
                text: rsv.venueDetails.sportCategory.categoryString,
                size: 14,
              ),
            ),
          ],
        ),
        IconWithText(
          icon: Icons.access_time,
          text: "${rsv.timeSlots.length} timeslots reserved",
          size: 14,
        ),
      ],
    );
  }
}

class MyRsvCardTitle extends StatelessWidget {
  final Reservation rsv;

  const MyRsvCardTitle(this.rsv, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            rsv.venueDetails.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class MyRsvCardTrailing extends StatelessWidget {
  final Reservation rsv;
  final String profileName;

  const MyRsvCardTrailing(this.rsv, this.profileName, {super.key});

  _onCancelPress(BuildContext context, Reservation rsv) async {
    showConfirmationDialog(
      context,
      "Cancel Reservation",
      () async {
        await context.read<ReservationProvider>().removeUserReservation(rsv);
        await context.read<ProfileProvider>().decrReservations();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return rsv.rsvPassed()
        ? rsv.reviewed == null
            ? IconButton(
                tooltip: "Give reviews",
                icon: Icon(Icons.reviews,
                    color: Theme.of(context).colorScheme.tertiary),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ReviewDialog(rsv, profileName);
                      });
                },
              )
            : const SizedBox.shrink()
        : IconButton(
            tooltip: "Cancel reservation",
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _onCancelPress(context, rsv),
          );
  }
}
