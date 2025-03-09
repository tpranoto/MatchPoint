import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/venue_detail_timeslot.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:matchpoint/providers/review_provider.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets(
      'Venue Detail Timeslot shows all available time slots based on provider source and clickable',
      (WidgetTester tester) async {
    final mockRsvProvider = MockReservationProvider();
    final mockReviewProvider = MockReviewProvider();
    when(mockRsvProvider.venueScheduleStream).thenAnswer((_) => Stream.value(
        RsStatusList(
            DateTime.now().add(Duration(days: 1)), getDefaultDailySchedule())));
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
            body: VenueDetailTimeslot(
                selectedDate: DateTime.now().add(Duration(days: 1))),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("07:00"), findsOneWidget);

    await tester.tap(find.text("07:00"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("07:00"));
    await tester.pumpAndSettle();
  });
}
