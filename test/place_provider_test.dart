import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/models/place.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/services/place.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'place_provider_test.mocks.dart';

@GenerateMocks([PlaceService])
void main() {
  //Testing initial state
  testWidgets('Testing initial state to be correct', (WidgetTester tester) async{
    final placeProvider = PlaceProvider();

    await tester.pumpWidget(
        MaterialApp(
            home: Scaffold(
                body: Column(
                  children: [
                    Text(placeProvider.getList.isEmpty ? "No Places" : "Has Places"),
                    Text(placeProvider.isLoading ? "Loading" : "Not Loading"),
                  ],
                )
            )
        )
    );
    expect(placeProvider.getList, []);
    expect(placeProvider.isLoading, false);
  });

  //Testing if the Fetching places is successful
  testWidgets('update should happen when fetchPlaces list on success', (WidgetTester tester) async {
    // Arrange
    final mockService = MockPlaceService();
    final placeProvider = PlaceProvider();
    final mockResponse = {
      "statusCode": 200,
      "results": ["A", "B"],
      "nextPage": "nextPage"
    };
    when(mockService.fetchNearbyPlacesNextPage(any)).thenAnswer((_) async => mockResponse);

    await tester.pumpWidget(
      ChangeNotifierProvider<PlaceProvider>.value(
        value: placeProvider,
        child: MaterialApp(
          home: Scaffold(body: Consumer<PlaceProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  Text(provider.errMsg),
                ],
              );
            },
          )),
        ),
      ),
    );

    await tester.runAsync(() async {
      await placeProvider.fetchNextPagePlaces();
    });
    await tester.pumpAndSettle();

    // Assert
    expect(placeProvider.errMsg, isEmpty);

  });

  //Checking addList
  testWidgets('addList should append new places', (WidgetTester tester) async {
    final placeProvider = PlaceProvider();

    placeProvider.addList([Place(
      id: "id1",
      name: "the tennis court",
      address: "123 Hey Ho",
      latitude: 48,
      longitude: -122,
      distance: 2,
      photoUrl: "",
      sportCategory: SportsCategories.tennis,
      priceInCent: 30,
      availableTimeslots: ["9:00"],
      ratings: 8.9,
      ratingsTotal: 12,
    ),
    ]);

    await tester.pumpWidget(
        MaterialApp(
            home: Text(
                placeProvider.getList[0].name
            )
        )
    );
    //Assert
    expect(find.text("the tennis court"), findsOneWidget);
  });
}