import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/firestore.dart';

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

  void saveProfileFromUser(User? gUser) async {
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

  void removeProfile() async {
    _currentProfile = null;
    notifyListeners();
  }
}
