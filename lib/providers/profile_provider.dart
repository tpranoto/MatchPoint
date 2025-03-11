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
    if (_currentProfile != null) {
      return;
    }
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
      await profileRef.set(newProfile.toMap());
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
    if (_currentProfile == null) return;

    final profileRef = _profileCollection.doc(_currentProfile!.id);

    await profileRef.update({
      'reservationsCount': FieldValue.increment(1),
    });

    _currentProfile!.reservationsCount++;
    notifyListeners();
  }

  Future<void> decrReservations() async {
    if (_currentProfile == null) return;

    final profileRef = _profileCollection.doc(_currentProfile!.id);

    if (_currentProfile!.reservationsCount > 0) {
      await profileRef.update({
        'reservationsCount': FieldValue.increment(-1),
      });
      _currentProfile!.reservationsCount--;
    }
    notifyListeners();
  }

  Future<void> incrReviews() async {
    if (_currentProfile == null) return;

    final profileRef = _profileCollection.doc(_currentProfile!.id);

    await profileRef.update({
      'reviewsCount': FieldValue.increment(1),
    });

    _currentProfile!.reservationsCount++;
    notifyListeners();
  }

  Future<void> updateFCMToken(String? token) async {
    if (_currentProfile == null || token == null) return;

    final profileRef = _profileCollection.doc(_currentProfile!.id);

    await profileRef.update({
      'fcmToken': token,
    });

    _currentProfile!.fcmToken = token;
    notifyListeners();
  }

  void removeProfile() {
    _currentProfile = null;
  }
}
