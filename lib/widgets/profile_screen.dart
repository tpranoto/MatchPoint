import 'package:flutter/material.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/services/firestore.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppProfileProvider profileProvider =
        Provider.of<AppProfileProvider>(context);

    final profileData = profileProvider.getData;

    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileData!.photoUrl),
            ),
            Text(
              profileData.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
