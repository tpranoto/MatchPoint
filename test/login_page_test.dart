import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/login_page.dart';
import 'package:matchpoint/widgets/profile_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';

import "profile_screen_test.mocks.dart";
import "login_page_test.mocks.dart";

@GenerateNiceMocks([MockSpec<User>()])
void main() {
  testWidgets('Login Page stays in Login Page if user is not authenticated.',
      (WidgetTester tester) async {
    final mockAuthService = MockAuthService();

    when(mockAuthService.loginChanges)
        .thenAnswer((_) => Stream.fromIterable([]));

    final mockProfileProv = MockAppProfileProvider();

    await tester.pumpWidget(
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
          child: Center(
            child: LoginPage(),
          ),
        ),
      ),
    );

    expect(find.text("Sign in with Google"), findsOneWidget);
  });
}
