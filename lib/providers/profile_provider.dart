import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../models/profile.dart';

class ProfileProvider extends ChangeNotifier {
  final CollectionReference _profileCollection;

  Profile? _currentProfile;

  ProfileProvider(FirebaseFirestore firestore)
      : _profileCollection = firestore.collection("profile");

  Profile get getProfile => _currentProfile!;

  Future<void> loadProfile(String uid) async {
    final profileRef = _profileCollection.doc(uid);
    final snapshot = await profileRef.get();
    if (!snapshot.exists) {
      throw Exception('error no profile found');
    }
    _currentProfile = Profile.fromMap(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }

  Future<void> loadAndSaveProfile(Auth auth) async {
    final profileRef = _profileCollection.doc(auth.uid);

    final snapshot = await profileRef.get();
    if (!snapshot.exists) {
      final newProfile = Profile.fromAuth(auth);
      await profileRef.set(newProfile);
      _currentProfile = newProfile;
      notifyListeners();
      return;
    }

    _currentProfile = Profile.fromMap(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
    notifyListeners();
  }

  Future<void> incrReservations() async {
    final profileRef = _profileCollection.doc(_currentProfile!.id);

    await profileRef.update({
      'reservationsCount': FieldValue.increment(1),
    });

    _currentProfile!.reservationsCount++;
    notifyListeners();
  }

  void removeProfile() {
    _currentProfile = null;
    notifyListeners();
  }
}
