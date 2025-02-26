import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/venue_detail_page.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets(
      'Venue Detail Page shows the venue data and reservations availability based on the passed in Object',
      (WidgetTester tester) async {
    final mockRsvProvider = MockReservationProvider();
    when(mockRsvProvider.venueScheduleStream).thenAnswer((_) => Stream.value(
        RsStatusList(DateTime(2025, 02, 28), getDefaultDailySchedule())));
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
            )
          ],
          child: VenueDetailPage(mockVenue),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("the tennis court"), findsOneWidget);
    expect(find.text("Make a reservation"), findsOneWidget);
    expect(find.text("Available timeslots"), findsOneWidget);
  });
}
