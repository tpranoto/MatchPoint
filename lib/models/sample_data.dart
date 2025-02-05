import 'package:matchpoint/models/static_data.dart';

import 'place.dart';

final List<Place> populatedPlaces = [
  Place(
    id: "4a945272f964a520332120e3",
    name: "Bobby Morris Playfield",
    address: "1635 11th Ave W (at E Pine St), Seattle, WA 98119",
    latitude: 47.634595,
    longitude: -122.372036,
    distance: 0.9,
    photoUrl: "",
    sportCategory: SportsCategories.soccer,
    priceInCent: SportsCategories.soccer.categoryBasedPrice,
    availableTimeslots: ["9:00", "10:00", "11:00", "12:00"],
    ratings: 4.9,
    ratingsTotal: 11,
  ),
  Place(
    id: "4beadfc99fa3ef3bd32f80c9",
    name: "Bobby Morris Playfield",
    address: "1600 Nagle Pl (at E Pine St.), Seattle, WA 98122",
    latitude: 47.615758,
    longitude: -122.319878,
    distance: 1.9,
    photoUrl: "",
    sportCategory: SportsCategories.tennis,
    priceInCent: SportsCategories.tennis.categoryBasedPrice,
    availableTimeslots: ["9:00", "10:00", "11:00", "12:00", "13:00"],
    ratings: 4.1,
    ratingsTotal: 47,
  )
];
