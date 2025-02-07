import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/login_page.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import "profile_screen_test.mocks.dart";

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
