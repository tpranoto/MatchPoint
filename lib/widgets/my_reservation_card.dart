import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_reservation_card_util.dart';
import '../models/reservation.dart';
import '../providers/profile_provider.dart';

class MyReservationCard extends StatefulWidget {
  final Reservation rsv;

  const MyReservationCard(this.rsv, {super.key});

  @override
  State<StatefulWidget> createState() => MyReservationCardState();
}

class MyReservationCardState extends State<MyReservationCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final profileProv = context.watch<ProfileProvider>();
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        spacing: 8,
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: MyRsvCardTitle(widget.rsv),
              subtitle: MyRsvDetails(widget.rsv),
              trailing:
                  MyRsvCardTrailing(widget.rsv, profileProv.getProfile.name),
              expandedAlignment: Alignment.centerLeft,
              children: [
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.rsv.timeSlots.map((ts) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 18, color: Colors.teal),
                            const SizedBox(width: 8),
                            Text(
                              ts.showTimeRange,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              onExpansionChanged: (expanded) {
                setState(() {
                  isExpanded = expanded;
                });
              },
            ),
          ),
          isExpanded
              ? SizedBox.shrink()
              : const Center(
                  child: Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey, size: 28),
                ),
        ],
      ),
    );
  }
}
