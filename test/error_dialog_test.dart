import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/widgets/common/error_dialog.dart';

void main() {
  testWidgets('Displays error dialog and dismisses on OK button press',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                errorDialog(context, "An error occurred!");
              },
              child: Text("Show Error Dialog"),
            );
          },
        ),
      ),
    );

    expect(find.text("Show Error Dialog"), findsOneWidget);

    await tester.tap(find.text("Show Error Dialog"));
    await tester.pumpAndSettle();

    expect(find.text("Error"), findsOneWidget);
    expect(find.text("An error occurred!"), findsOneWidget);
    expect(find.text("OK"), findsOneWidget);

    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    expect(find.text("Error"), findsNothing);
  });
}
