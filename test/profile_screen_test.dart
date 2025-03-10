import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/profile_screen.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/auth_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/providers/venue_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets(
      'Profile Screen shows basic information based on current profile info',
      (WidgetTester tester) async {
    final mockProfileProvider = MockProfileProvider();
    final mockAuthProvider = MockAppAuthProvider();
    final mockVenueProvider = MockVenueProvider();

    when(mockProfileProvider.getProfile).thenReturn(Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    ));

    await mockNetworkImages(() async => tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<ProfileProvider>.value(
                  value: mockProfileProvider,
                ),
                Provider<AppAuthProvider>.value(
                  value: mockAuthProvider,
                ),
                ChangeNotifierProvider<VenueProvider>.value(
                  value: mockVenueProvider,
                )
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
    final mockProfileProvider = MockProfileProvider();
    final mockAuthProvider = MockAppAuthProvider();
    final mockVenueProvider = MockVenueProvider();

    when(mockProfileProvider.getProfile).thenReturn(Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    ));

    await mockNetworkImages(() async => await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<ProfileProvider>.value(
                  value: mockProfileProvider,
                ),
                Provider<AppAuthProvider>.value(
                  value: mockAuthProvider,
                ),
                ChangeNotifierProvider<VenueProvider>.value(
                  value: mockVenueProvider,
                )
              ],
              child: Scaffold(
                body: ProfileScreen(),
              ),
            ),
          ),
        ));

    await tester.tap(find.text("Log Out"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Confirm"));

    verify(mockAuthProvider.signOut());
  });
}
