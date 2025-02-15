import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/auth.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  late Auth _authData;

  AppAuthProvider(this._firebaseAuth);

  Auth get getData => _authData;

  Stream<Auth?> get stateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        return Auth.fromUser(user);
      }
      return null;
    });
  }

  Future<void> signInWithGoogle() async {
    final googleAuth = await GoogleSignIn().signIn();
    if (googleAuth == null) {
      throw Exception('error signing in with Google');
    }

    final GoogleSignInAuthentication gAuth = await googleAuth.authentication;
    final OAuthCredential creds = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );

    final UserCredential signInCreds =
        await _firebaseAuth.signInWithCredential(creds);
    if (signInCreds.user != null) {
      _authData = Auth.fromUser(signInCreds.user!);
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    return await _firebaseAuth.signOut();
  }
}
