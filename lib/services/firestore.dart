import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchpoint/models/profile.dart';

class FirestoreService {
  final CollectionReference profileRef =
      FirebaseFirestore.instance.collection("profile");

  Profile? addProfileIfNotExists(Profile currProf) {
    final ref = profileRef.doc(currProf.id);
    try {
      ref.get().then((snapshot) {
        if (!snapshot.exists) {
          ref.set(currProf.toMap());
          return currProf;
        } else {
          final foundProfile = getById(currProf.id);
          return foundProfile;
        }
      });
    } catch (e) {
      print("Error adding profile: $e");
      return null;
    }
    return null;
  }

  Future<Profile?> getById(String id) async {
    final ref = profileRef.doc(id);

    try {
      final snapshot = await ref.get();
      // Fetch the document snapshot asynchronously
      if (snapshot.exists) {
        final data = Profile.fromMap(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        );

        return data;
      } else {
        // Profile does not exist
        print("Profile not found for ID: $id");
        return null;
      }
    } catch (e) {
      // Handle errors such as network issues, etc.
      print("Error fetching profile: $e");
      return null;
    }
  }
}
