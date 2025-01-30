import 'package:flutter/material.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../services/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppProfileProvider profileProvider =
        context.watch<AppProfileProvider>();
    final profileData = profileProvider.getData;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileInfo(profileData),
            _profileAppStats(profileData),
            _logoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _profileInfo(Profile? profileData) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(profileData!.photoUrl),
        ),
        Text(
          profileData.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          profileData.email,
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }

  Widget _profileAppStats(Profile? profileData) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: _profileAppStatsData(
                "Reservations",
                profileData!.reservationsCount,
              ),
            ),
            Expanded(
              child: _profileAppStatsData(
                "Reviews",
                profileData.reviewsCount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileAppStatsData(String title, int count) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          "$count",
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showConfirmationDialog(
                context,
                "Log Out",
                AuthService().signOut,
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(0xFFFFCCCC)),
            ),
            child: Row(
              spacing: 10,
              children: [
                Icon(Icons.logout),
                Text("Logout"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
