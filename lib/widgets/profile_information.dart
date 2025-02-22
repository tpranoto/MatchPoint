import 'package:flutter/material.dart';
import 'common.dart';
import '../models/profile.dart';

class ProfileInfo extends StatelessWidget {
  final Profile profileData;
  const ProfileInfo({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(profileData.photoUrl),
        ),
        CenteredTitle(profileData.name, size: 22),
        Text(
          profileData.email,
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  final Profile profileData;

  const ProfileStats({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return PaddedCard(
      padding: 15,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
    );
  }

  Widget _profileAppStatsData(String title, int count) {
    return Column(
      children: [
        CenteredTitle(title, size: 18),
        SizedBox(
          height: 5.0,
        ),
        CenteredTitle("$count", size: 20),
      ],
    );
  }
}
