import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final _googleSignIn = GoogleSignIn();

  AuthService(this._firebaseAuth);

  Stream<User?> get loginChanges {
    return _firebaseAuth.authStateChanges();
  }

  Future<User?> signInWithGoogle() async {
    final googleAuth = await _googleSignIn.signIn();
    if (googleAuth == null) {
      return null;
    }

    final GoogleSignInAuthentication gAuth = await googleAuth.authentication;
    final OAuthCredential creds = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );

    final UserCredential signInCreds =
        await _firebaseAuth.signInWithCredential(creds);
    if (signInCreds.user != null) {
      return signInCreds.user!;
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return await _firebaseAuth.signOut();
  }
}
