import 'package:flutter/material.dart';
import 'package:matchpoint/widgets/common.dart';
import 'package:matchpoint/widgets/profile_information.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';

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
            ProfileStats(profileData: profileData),
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
                },
              );
            },
            icon: Icon(Icons.logout),
            bg: Color(0xFFFFCCCC),
          ),
        ),
      ],
    );
  }
}
