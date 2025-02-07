import 'package:flutter/material.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/common.dart';
import 'package:matchpoint/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileData = context.watch<AppProfileProvider>().getData;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ProfileInfo(profileData: profileData!),
            _ProfileStats(profileData: profileData),
            _LogOutButton(),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final Profile profileData;
  const _ProfileInfo({required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(profileData.photoUrl),
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
}

class _ProfileStats extends StatelessWidget {
  final Profile profileData;

  const _ProfileStats({required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: _profileAppStatsData(
                "Reservations",
                profileData.reservationsCount,
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
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton();

  @override
  Widget build(BuildContext context) {
    final AppProfileProvider profileProvider =
        context.read<AppProfileProvider>();
    final authProvider = context.read<AuthService>();
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showConfirmationDialog(
                context,
                "Log Out",
                () {
                  authProvider
                      .signOut()
                      .then((_) => profileProvider.removeProfile());
                },
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(0xFFFFCCCC)),
            ),
            child: IconWithText(
              icon: Icons.logout,
              text: "Logout",
              textColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
