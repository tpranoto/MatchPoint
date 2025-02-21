import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/widgets/disabled_permission_page.dart';

void main() {
  testWidgets('Disabled permission page Screen shows basic information.',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: DisabledPermissionPage()),
        );

        expect(
            find.text(
                'Match Point needs your permission to get your current location to get nearby sports venues.'),
            findsOneWidget);
      });
}
