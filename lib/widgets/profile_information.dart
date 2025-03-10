import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import '../models/profile.dart';
import '../providers/profile_provider.dart';

class ProfileInfo extends StatelessWidget {
  final Profile profileData;
  const ProfileInfo({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 90,
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
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return PaddedCard(
      padding: 15,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Row(
        children: [
          Expanded(
            child: _profileAppStatsData(
              "Reservations",
              profileProvider.getProfile.reservationsCount,
            ),
          ),
          Expanded(
            child: _profileAppStatsData(
              "Reviews",
              profileProvider.getProfile.reviewsCount,
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
