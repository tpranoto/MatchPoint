import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';

class MyReservationPage extends StatefulWidget {
  final String profileId;

  const MyReservationPage({super.key, required this.profileId});

  @override
  State<MyReservationPage> createState() => _MyReservationPageState();
}

class _MyReservationPageState extends State<MyReservationPage> {
  late Future<List<Reservation>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _reservationsFuture = Provider.of<ReservationProvider>(context, listen: false)
        .getUserReservations(widget.profileId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Reservation>>(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading reservations"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No reservations found",
                    style: TextStyle(fontSize: 18, color: Colors.grey
                      ),
                  ),
                ],
              ),
            );
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final rsv = reservations[index];

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
                                rsv.venueName,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                      Icons.calendar_today,
                                      size: 16, color: Colors.blueGrey
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    rsv.reservationDate.toLocal().toString().split(' ')[0],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blueGrey
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.blueGrey
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    rsv.timeSlots.map((ts) => formatTimeSlot(ts)).join(", "),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey
                                    ),
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

  String formatTimeSlot(int slot) {
    const timeSlots = [
      "6:00 AM - 7:00 AM", "7:00 AM - 8:00 AM", "8:00 AM - 9:00 AM",
      "9:00 AM - 10:00 AM", "10:00 AM - 11:00 AM", "11:00 AM - 12:00 PM",
      "12:00 PM - 1:00 PM", "1:00 PM - 2:00 PM", "2:00 PM - 3:00 PM",
      "3:00 PM - 4:00 PM", "4:00 PM - 5:00 PM", "5:00 PM - 6:00 PM",
      "6:00 PM - 7:00 PM", "7:00 PM - 8:00 PM"
    ];
    return timeSlots[slot];
  }

  Future<void> _cancelReservation(BuildContext context, Reservation rsv) async {
    final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    await reservationProvider.removeReservation(rsv);
    await profileProvider.decrReservations();

    if (mounted) {
      setState(() {
        _reservationsFuture = reservationProvider.getUserReservations(widget.profileId);
      });
    }
  }
}
