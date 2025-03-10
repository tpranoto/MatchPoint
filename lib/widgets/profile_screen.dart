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
    return Scaffold(
      body: Container( decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.indigo.shade100],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        ),
      ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileInfo(profileData: profileData),
                ProfileStats(),
                _MyReviewsButton(),
                _LogOutButton(),
              ],
            ),
          ),
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
    return _styledButton(
      text: "My Reviews",
      icon: Icons.reviews,
      bgColor: Colors.white,
      textColor: Colors.black,
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => MyReviewPage(profile.id)));
      },
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

    return _styledButton(
      text: "Log Out",
      icon: Icons.logout,
      bgColor: Colors.redAccent.shade200,
      textColor: Colors.white,
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
    );
  }
}

Widget _styledButton({
  required String text,
  required IconData icon,
  required Color bgColor,
  required Color textColor,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: bgColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        shadowColor: Colors.black38,
      ),
      icon: Icon(icon, size: 22),
      label: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
    ),
  );
}