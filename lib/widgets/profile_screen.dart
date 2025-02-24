import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'profile_information.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/venue_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileData = context.watch<ProfileProvider>().getProfile;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileInfo(profileData: profileData),
            ProfileStats(),
            _LogOutButton(),
          ],
        ),
      ),
    );
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton();

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();
    final authProvider = context.read<AppAuthProvider>();
    final venueProvider = context.read<VenueProvider>();
    return Row(
      children: [
        Expanded(
          child: SquaredButton(
            text: "Log Out",
            onPressed: () {
              showConfirmationDialog(
                context,
                "Log Out",
                () async {
                  await authProvider.signOut();
                  profileProvider.removeProfile();
                  venueProvider.resetVenues();
                },
              );
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            bg: Colors.redAccent,
            fg: Colors.white,
          ),
        ),
      ],
    );
  }
}
