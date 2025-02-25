import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';

import 'common/error_dialog.dart';
import 'common/mp_future_builder.dart';

class MyReservationPage extends StatefulWidget {
  const MyReservationPage({super.key});

  @override
  State<MyReservationPage> createState() => _MyReservationPageState();
}

class _MyReservationPageState extends State<MyReservationPage> {
  @override
  Widget build(BuildContext context) {
    final rsvProvider = context.watch<ReservationProvider>();
    final profileProvider = context.read<ProfileProvider>();

    return Scaffold(
      body: MPFutureBuilder(
        future:
            rsvProvider.loadReservationByUser(profileProvider.getProfile.id),
        onSuccess: (context, snapshot) {
          if (snapshot.hasError) {
            errorDialog(context, "${snapshot.error}");
            return Center(child: Text("Error loading reservations"));
          }

          if (rsvProvider.userReservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No reservations found",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: rsvProvider.userReservations.length,
            itemBuilder: (context, index) {
              final rsv = rsvProvider.userReservations[index];

              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Card(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rsv.venueDetails.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 16, color: Colors.blueGrey),
                                  SizedBox(width: 6),
                                  Text(
                                    rsv.reservationDate
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 16, color: Colors.blueGrey),
                                  SizedBox(width: 6),
                                  Text(
                                    rsv.timeSlots.map((ts) => ts).join(", "),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _cancelReservation(context, rsv),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _cancelReservation(BuildContext context, Reservation rsv) async {
    // final reservationProvider =
    //     Provider.of<ReservationProvider>(context, listen: false);
    // final profileProvider =
    //     Provider.of<ProfileProvider>(context, listen: false);
    //
    // await reservationProvider.removeReservation(rsv);
    // await profileProvider.decrReservations();
    //
    // if (mounted) {
    //   setState(() {
    //     _reservationsFuture =
    //         reservationProvider.getUserReservations(widget.profileId);
    //   });
    // }
  }
}
