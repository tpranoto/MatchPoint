import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'my_reservation_card.dart';
import '../providers/reservation_provider.dart';
import '../providers/profile_provider.dart';

class MyReservationScreen extends StatelessWidget {
  const MyReservationScreen({super.key});

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
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: rsvProvider.userReservations.length,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: MyReservationCard(rsvProvider.userReservations[index]),
              );
            },
          );
        },
      ),
    );
  }
}
