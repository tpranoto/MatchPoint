import 'package:flutter/material.dart';

class DisabledPermissionPage extends StatelessWidget {
  const DisabledPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          children: [
            Expanded(
              flex: 3,
              child: Image(
                image: AssetImage("assets/matchpoint.png"),
                width: 100,
                height: 100,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "Match Point needs your permission to get your current location to get nearby sports venues.",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
