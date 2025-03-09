import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/rsv_confirmation_page.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/timeslot.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'package:matchpoint/providers/review_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets(
      'Rsv Confirmation Page shows the summary of reservation and payment based on venues and selected date from the constructor and Confirm works.',
      (WidgetTester tester) async {
    final mockProfileProvider = MockProfileProvider();
    final mockRsvProvider = MockReservationProvider();
    final mockReviewProvider = MockReviewProvider();

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

    when(mockProfileProvider.getProfile).thenReturn(Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    ));

    when(mockRsvProvider.selectedTimeslots).thenReturn([TimeSlot.second]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfileProvider>.value(
            value: mockProfileProvider,
          ),
          ChangeNotifierProvider<ReservationProvider>.value(
            value: mockRsvProvider,
          ),
          Provider<ReviewProvider>.value(
            value: mockReviewProvider,
          ),
        ],
        child: MaterialApp(
          home: RsvConfirmationPage(mockVenue, DateTime(2025, 02, 24)),
        ),
      ),
    );

    expect(find.text("Confirmation"), findsOneWidget);
    expect(find.text("the tennis court"), findsOneWidget);
    expect(find.text("Payment Summary"), findsOneWidget);
    expect(find.text("08:00 - 09:00"), findsOneWidget);

    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    verify(mockProfileProvider.incrReservations()).called(1);
    verify(mockRsvProvider.createReservation(any)).called(1);
  });
}
