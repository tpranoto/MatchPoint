import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/firestore.dart';

class AppProfileProvider extends ChangeNotifier {
  final FirestoreService firestoreService;

  Profile? _currentProfile;

  AppProfileProvider({required this.firestoreService});

  Profile? get getData {
    return _currentProfile;
  }

  Future<void> loadAndSaveProfile(String uid) async {
    final storedProfile = await firestoreService.getById(uid);
    _currentProfile = storedProfile;
    notifyListeners();
  }

  void saveProfileFromUser(User? gUser) {
    if (gUser == null) {
      return;
    }

    final appProfile =
        firestoreService.addProfileIfNotExists(Profile.fromUser(gUser));
    if (appProfile == null) {
      return;
    }
    _currentProfile = appProfile;
    notifyListeners();
  }

  void removeProfile() {
    _currentProfile = null;
    notifyListeners();
  }
}
