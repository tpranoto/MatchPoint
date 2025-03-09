import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/venue_detail_reviews.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/models/review.dart';
import 'package:matchpoint/providers/review_provider.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets(
      'Venue Detail Review shows the ratings and reviews based on the passed in Object',
      (WidgetTester tester) async {
    final mockRsvProvider = MockReservationProvider();
    final mockReviewProvider = MockReviewProvider();

    when(mockReviewProvider.ratings).thenReturn(4.8);
    when(mockReviewProvider.venueReviewData).thenReturn([
      Review(
          venueId: "id1",
          profileId: "pId1",
          rsvId: "rsvId1",
          rating: 4,
          comment: "this is a comment",
          name: "Hur dur",
          createdAt: DateTime.now())
    ]);

    final mockVenue = Venue(
      id: "id1",
      name: "the tennis court",
      address: "123 Hey Ho",
      latitude: 48,
      longitude: -122,
      distance: 2,
      photoUrls: [],
      sportCategory: SportsCategories.tennis,
      priceInCent: 30,
      ratings: 4.9,
      ratingsTotal: 12,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ReservationProvider>.value(
              value: mockRsvProvider,
            ),
            Provider<ReviewProvider>.value(
              value: mockReviewProvider,
            ),
          ],
          child: Scaffold(
            body: VenueDetailReviews(mockVenue),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("4.8"), findsOneWidget);
    expect(find.text("13 ratings"), findsOneWidget);
    expect(find.text("this is a comment"), findsOneWidget);
  });
}
