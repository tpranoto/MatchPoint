import 'package:flutter/material.dart';

class DisabledPermissionPage extends StatelessWidget {
  const DisabledPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 100,
          ),
          Text(
            "Match Point needs your permission to get your current location to get nearby sports venues.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
