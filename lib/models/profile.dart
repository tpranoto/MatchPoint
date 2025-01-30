import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../services/auth.dart';
import '../services/firestore.dart';

class Profile {
  final String id;
  final String email;
  final String name;
  final String phoneNum;
  final String photoUrl;
  final int reservationsCount;
  final int reviewsCount;

  Profile(this.id, this.email, this.name, this.phoneNum, this.photoUrl,
      this.reservationsCount, this.reviewsCount);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNum': phoneNum,
      'photoUrl': photoUrl,
      'reservationsCount': reservationsCount,
      'reviewsCount': reviewsCount,
    };
  }

  factory Profile.fromUser(User? user) {
    return Profile(
      user!.uid,
      user.email ?? "",
      user.displayName ?? "",
      user.phoneNumber ?? "",
      user.photoURL ?? "",
      0,
      0,
    );
  }

  factory Profile.fromMap(Map<String, dynamic> data, String id) {
    return Profile(
      id,
      data['email'],
      data['name'],
      data['phoneNum'],
      data['photoUrl'],
      data['reservationsCount'] ?? 0,
      data['reviewsCount'] ?? 0,
    );
  }
}

class AppProfileProvider extends ChangeNotifier {
  Profile? _currentProfile;

  Profile? get getData {
    return _currentProfile;
  }

  void loadAndSaveProfile(String uid) async {
    final storedProfile = await FirestoreService().getById(uid);
    _currentProfile = storedProfile;
    notifyListeners();
  }

  void signInAndSaveProfile() async {
    final gUser = await AuthService().signInWithGoogle();
    if (gUser == null) {
      return;
    }

    final appProfile =
        FirestoreService().addProfileIfNotExists(Profile.fromUser(gUser));
    if (appProfile == null) {
      return;
    }
    _currentProfile = appProfile;
    notifyListeners();
  }

  void saveProfile(Profile? curr) {
    _currentProfile = curr;
    notifyListeners();
  }
}
