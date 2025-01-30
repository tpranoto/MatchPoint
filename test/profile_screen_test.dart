import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/widgets/profile_screen.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
      'Profile Screen shows basic information based on current profile info',
      (WidgetTester tester) async {
    final mockProfile = Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    );
    final prov = AppProfileProvider();
    prov.saveProfile(mockProfile);

    await mockNetworkImages(() async => tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<AppProfileProvider>.value(
              value: prov,
              child: Scaffold(
                body: ProfileScreen(),
              ),
            ),
          ),
        ));

    expect(find.text('Hey Ho'), findsOneWidget);
    expect(find.text('myemail@gmail.com'), findsOneWidget);
    expect(find.text("13"), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
  });
}
