import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:matchpoint/providers/reservation_provider.dart';

class MyReservationPage extends StatefulWidget {
  final String profileId;

  const MyReservationPage({super.key, required this.profileId});

  @override
  State <MyReservationPage> createState() => _MyReservationPageState();
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
            return Center(child: Text("No reservations found"));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final rsv = reservations[index];
              return Card(
                child: ListTile(
                  title: Text("Venue: ${rsv.venueId}"),
                  subtitle: Text(
                    "Date: ${rsv.reservationDate.toLocal()} \nTimeslots: ${rsv.timeSlots.map((ts) => "Slot ${ts + 1}").join(", ")}",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _cancelReservation(context, rsv),
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
    await Provider.of<ReservationProvider>(context, listen: false).removeReservation(rsv);
    setState(() {
      _reservationsFuture = Provider.of<ReservationProvider>(context, listen: false)
          .getUserReservations(widget.profileId);
    });
  }
}
