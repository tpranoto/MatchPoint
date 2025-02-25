import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import '../models/reservation.dart';
import '../providers/profile_provider.dart';
import '../providers/reservation_provider.dart';

class MyReservationCard extends StatelessWidget {
  final Reservation rsv;
  const MyReservationCard(this.rsv, {super.key});

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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rsv.venueDetails.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconWithText(
                    icon: Icons.calendar_today,
                    text:
                        rsv.reservationDate.toLocal().toString().split(' ')[0],
                    size: 14,
                  ),
                  IconWithText(
                    icon: Icons.access_time,
                    text: "${rsv.timeSlots.length} timeslots reserved",
                    size: 14,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _onCancelPress(context, rsv),
            ),
          ],
        ),
      ),
    );
  }
}
