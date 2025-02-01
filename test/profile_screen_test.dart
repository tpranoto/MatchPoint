import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/profile_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';

import "profile_screen_test.mocks.dart";

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<AppProfileProvider>()])
void main() {
  testWidgets(
      'Profile Screen shows basic information based on current profile info',
      (WidgetTester tester) async {
    final mockAuthService = MockAuthService();

    final mockProfile = Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    );
    final mockProfileProv = MockAppProfileProvider();
    when(mockProfileProv.getData).thenReturn(mockProfile);

    await mockNetworkImages(() async => tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                Provider<AuthService>.value(
                  value: mockAuthService,
                ),
                ChangeNotifierProvider<AppProfileProvider>.value(
                  value: mockProfileProv,
                ),
              ],
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

  testWidgets('Logout button will call sign out function on AuthService',
      (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    when(mockAuthService.signOut()).thenAnswer((_) async {});

    final mockProfile = Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    );
    final mockProfileProv = MockAppProfileProvider();
    when(mockProfileProv.getData).thenReturn(mockProfile);

    await mockNetworkImages(() async => await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                Provider<AuthService>.value(
                  value: mockAuthService,
                ),
                ChangeNotifierProvider<AppProfileProvider>.value(
                  value: mockProfileProv,
                ),
              ],
              child: Scaffold(
                body: ProfileScreen(),
              ),
            ),
          ),
        ));

    await tester.tap(find.text("Logout"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Confirm"));

    verify(mockAuthService.signOut());
  });
}
