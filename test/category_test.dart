import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/category.dart';

void main() {
  test('get foursquare ids based on category enum', () {
    final id = SportsCategories.volleyball.category4SCode;

    expect(id, equals("4eb1bf013b7b6f98df247e07"));
  });

  test('get price in cents based on category enum', () {
    final priceInCents = SportsCategories.volleyball.categoryBasedPrice;

    expect(priceInCents, equals(3500));
  });

  test('get category enum based on passed string', () {
    final category = categoryEnum("Volleyball Court");

    expect(category, equals(SportsCategories.volleyball));
  });
}
