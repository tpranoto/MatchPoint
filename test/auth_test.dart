import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:matchpoint/models/auth.dart';
import 'auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<User>()])
void main() {
  test('Create an Auth object from User', () {
    final mockUser = MockUser();
    when(mockUser.uid).thenReturn("uid1");
    when(mockUser.email).thenReturn("myemail@gmail.com");
    when(mockUser.displayName).thenReturn("Hey Ho");
    when(mockUser.photoURL).thenReturn("http://my-profile-pic");

    final auth = Auth.fromUser(mockUser);

    expect(auth.uid, equals("uid1"));
    expect(auth.email, equals("myemail@gmail.com"));
    expect(auth.displayName, equals("Hey Ho"));
    expect(auth.photoUrl, equals("http://my-profile-pic"));
  });
}
