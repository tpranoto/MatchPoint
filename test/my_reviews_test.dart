import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/my_review_page.dart';
import 'package:matchpoint/models/review.dart';
import 'package:matchpoint/providers/review_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets('My Review Page shows available reviews based on the provider.',
      (WidgetTester tester) async {
    final mockReviewProvider = MockReviewProvider();

    when(mockReviewProvider.userReviewData).thenReturn([
      Review(
          venueId: "id1",
          profileId: "pId1",
          rsvId: "rsvId1",
          rating: 4,
          comment: "this is a comment",
          name: "Hur dur",
          createdAt: DateTime.now())
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(providers: [
          Provider<ReviewProvider>.value(
            value: mockReviewProvider,
          ),
        ], child: MyReviewPage("pId1")),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsOneWidget);
    expect(find.text("this is a comment"), findsOneWidget);
  });

  testWidgets(
      'My Review Page shows empty reviews text when there are no reviews based on the provider.',
      (WidgetTester tester) async {
    final mockReviewProvider = MockReviewProvider();

    when(mockReviewProvider.userReviewData).thenReturn([]);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(providers: [
          Provider<ReviewProvider>.value(
            value: mockReviewProvider,
          ),
        ], child: MyReviewPage("pId1")),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
    expect(find.text("No reviews available"), findsOneWidget);
  });
}
