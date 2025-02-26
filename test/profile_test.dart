import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/models/auth.dart';

void main() {
  test('Create a Profile object from Auth object.', () {
    final mockAuth =
        Auth("uid1", "myemail@gmail.com", "Hey Ho", "http://my-profile-pic");

    final profile = Profile.fromAuth(mockAuth);

    expect(profile.id, equals("uid1"));
    expect(profile.email, equals("myemail@gmail.com"));
    expect(profile.name, equals("Hey Ho"));
    expect(profile.photoUrl, equals("http://my-profile-pic"));
    expect(profile.reservationsCount, equals(0));
    expect(profile.reviewsCount, equals(0));
  });

  test('Create a Profile object from Map of data.', () {
    final Map<String, dynamic> mockData = {
      "email": "myemail@gmail.com",
      "name": "Hey Ho",
      "photoUrl": "http://my-profile-pic",
      "reservationsCount": 23,
      "reviewsCount": 1,
    };

    final profile = Profile.fromMap(mockData, "uid1");

    expect(profile.id, equals("uid1"));
    expect(profile.email, equals("myemail@gmail.com"));
    expect(profile.name, equals("Hey Ho"));
    expect(profile.photoUrl, equals("http://my-profile-pic"));
    expect(profile.reservationsCount, equals(23));
    expect(profile.reviewsCount, equals(1));
  });
}
