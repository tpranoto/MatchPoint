import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  String uid;
  String email;
  String displayName;
  String photoUrl;

  Auth(this.uid, this.email, this.displayName, this.photoUrl);

  factory Auth.fromUser(User user) {
    return Auth(
      user.uid,
      user.email ?? "",
      user.displayName ?? "",
      user.photoURL ?? "",
    );
  }
}
