import 'package:flutter/material.dart';
import 'package:matchpoint/widgets/my_review_page.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'entry.dart';
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
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileInfo(profileData: profileData),
            ProfileStats(),
            SizedBox(height: 20),
            _MyReviewsButton(),
            _LogOutButton(),
          ],
        ),
      ),
    );
  }
}

class _MyReviewsButton extends StatelessWidget {
  const _MyReviewsButton();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().getProfile;

    return Row(
      children: [
        Expanded(
          child: SquaredButton(
            text: "My Reviews",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => MyReviewPage(profile.id)));
            },
            icon: Icon(
              Icons.reviews,
            ),
          ),
        ),
      ],
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
                  venueProvider.resetVenues();
                  profileProvider.removeProfile();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => Entry()),
                      (Route<dynamic> route) => false);
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
