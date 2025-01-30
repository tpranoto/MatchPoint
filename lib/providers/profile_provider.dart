import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/auth.dart';
import '../services/firestore.dart';

class AppProfileProvider extends ChangeNotifier {
  Profile? _currentProfile;

  Profile? get getData {
    return _currentProfile;
  }

  void saveProfile(Profile? currentProfile) {
    _currentProfile = currentProfile;
    notifyListeners();
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

  void signOutAndRmProfile() async {
    await AuthService().signOut();
    _currentProfile = null;
    notifyListeners();
  }
}
