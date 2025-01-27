import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference profile =
      FirebaseFirestore.instance.collection("profile");

  addProfileIfNotExists(User? userDt) {
    if (userDt == null) {
      return;
    }

    final ref = profile.doc(userDt.uid);
    ref.get().then((snapshot) {
      if (!snapshot.exists) {
        ref.set({
          "email": userDt.email,
          "name": userDt.displayName,
          "phoneNum": userDt.phoneNumber,
          "photoUrl": userDt.photoURL,
        });
      }
    });
  }
}
