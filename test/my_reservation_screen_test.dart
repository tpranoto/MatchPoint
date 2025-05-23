import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:matchpoint/widgets/my_reservation_screen.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/reservation.dart';
import 'package:matchpoint/models/timeslot.dart';
import 'package:matchpoint/models/venue.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/providers/reservation_provider.dart';
import 'package:matchpoint/providers/review_provider.dart';
import 'main_scaffold_test.mocks.dart';

void main() {
  testWidgets(
      'My Reservation Screen shows list of 1 reservation when there is a reservation done.',
      (WidgetTester tester) async {
    final mockProfileProvider = MockProfileProvider();
    final mockRsvProvider = MockReservationProvider();

    when(mockProfileProvider.getProfile).thenReturn(Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    ));

    when(mockRsvProvider.userReservations).thenReturn([
      Reservation(
        venueId: "venueId1",
        profileId: "id1",
        createdAt: DateTime.now(),
        reservationDate: DateTime(2025, 02, 24),
        timeSlots: [TimeSlot.second],
        venueDetails: Venue(
          id: "id1",
          name: "the tennis court",
          address: "123 Hey Ho",
          latitude: 48,
          longitude: -122,
          distance: 2,
          photoUrls: [],
          sportCategory: SportsCategories.tennis,
          priceInCent: 30,
          ratings: 8.9,
          ratingsTotal: 12,
        ),
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProfileProvider>.value(
              value: mockProfileProvider,
            ),
            ChangeNotifierProvider<ReservationProvider>.value(
              value: mockRsvProvider,
            )
          ],
          child: Scaffold(
            body: MyReservationScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsOneWidget);
    expect(find.text("the tennis court"), findsOneWidget);
    expect(find.text("1 timeslots reserved"), findsOneWidget);
  });

  testWidgets(
      'My Reservation Screen shows list of no reservation msg when there are no reservations done.',
      (WidgetTester tester) async {
    final mockProfileProvider = MockProfileProvider();
    final mockRsvProvider = MockReservationProvider();

    when(mockProfileProvider.getProfile).thenReturn(Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    ));

    when(mockRsvProvider.userReservations).thenReturn([]);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProfileProvider>.value(
              value: mockProfileProvider,
            ),
            ChangeNotifierProvider<ReservationProvider>.value(
              value: mockRsvProvider,
            )
          ],
          child: Scaffold(
            body: MyReservationScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
    expect(find.text("No reservations found"), findsOneWidget);
  });

  testWidgets('Submit new review from my reservation screen.',
      (WidgetTester tester) async {
    final mockProfileProvider = MockProfileProvider();
    final mockRsvProvider = MockReservationProvider();
    final mockReviewProvider = MockReviewProvider();

    when(mockReviewProvider.addMyNewReview(any)).thenAnswer((_) async => {});

    when(mockProfileProvider.getProfile).thenReturn(Profile(
      "id1",
      "myemail@gmail.com",
      "Hey Ho",
      "http://my-profile-pic",
      13,
      1,
    ));

    when(mockRsvProvider.userReservations).thenReturn([
      Reservation(
        rsvId: "rsvId1",
        venueId: "venueId1",
        profileId: "id1",
        createdAt: DateTime.now(),
        reservationDate: DateTime(2025, 02, 24),
        timeSlots: [TimeSlot.second],
        venueDetails: Venue(
          id: "id1",
          name: "the tennis court",
          address: "123 Hey Ho",
          latitude: 48,
          longitude: -122,
          distance: 2,
          photoUrls: [],
          sportCategory: SportsCategories.tennis,
          priceInCent: 30,
          ratings: 8.9,
          ratingsTotal: 12,
        ),
      ),
    ]);

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
          home: Scaffold(
            body: MyReservationScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsOneWidget);
    expect(find.text("the tennis court"), findsOneWidget);
    expect(find.text("1 timeslots reserved"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.reviews));
    await tester.pumpAndSettle();

    expect(find.text("Review Your Reservation"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();

    verify(mockReviewProvider.addMyNewReview(any)).called(1);
    verify(mockProfileProvider.incrReviews()).called(1);
    verify(mockRsvProvider.userReservationReviewed(any)).called(1);
  });
}
