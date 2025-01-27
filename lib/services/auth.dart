import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:matchpoint/services/firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get getCurrentUser {
    return _firebaseAuth.currentUser;
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser == null) {
      return;
    }

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final OAuthCredential creds = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );

    final UserCredential signInCreds =
        await _firebaseAuth.signInWithCredential(creds);

    FirestoreService().addProfileIfNotExists(signInCreds.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
