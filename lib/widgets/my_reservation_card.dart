import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'review_input_dialog.dart';
import '../providers/profile_provider.dart';
import '../providers/reservation_provider.dart';
import '../models/reservation.dart';
import '../models/category.dart';

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
    final profileProv = context.watch<ProfileProvider>();
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
      children: [
        Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(rsv.venueDetails.name,
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
          ),
          subtitle: _RsvDetails(rsv),
          trailing: rsv.rsvPassed()
              ? rsv.reviewed == null
                  ? IconButton(
                      tooltip: "Give reviews",
                      icon: Icon(Icons.reviews,
                          color: Theme.of(context).colorScheme.tertiary),
                      onPressed: () {
                        showDialog(context: context, builder: (BuildContext context) {
                              return ReviewDialog(rsv, profileProv.getProfile.name);
                            });
                      },
                    )
                  : const SizedBox.shrink()
              : IconButton(
                  tooltip: "Cancel reservation",
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _onCancelPress(context, rsv),
                ),
          expandedAlignment: Alignment.centerLeft,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rsv.timeSlots.map((ts) {
                  return Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(ts.showTimeRange, style: const TextStyle(fontSize: 14),),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Center(child: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 28),),
        const SizedBox(height: 8),
      ],
      ),
    );
  }
}

class _RsvDetails extends StatelessWidget {
  final Reservation rsv;
  const _RsvDetails(this.rsv);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: IconWithText(icon: Icons.calendar_today, text: rsv.reservationDate.toLocal().toString().split(' ')[0], size: 14,
              ),
            ),
            Flexible(child: IconWithText(icon: Icons.sports_soccer_outlined, text: rsv.venueDetails.sportCategory.categoryString, size: 14,
              ),
            ),
          ],
        ),
        IconWithText(icon: Icons.access_time, text: "${rsv.timeSlots.length} timeslots reserved", size: 14,
        ),
      ],
    );
  }
}
