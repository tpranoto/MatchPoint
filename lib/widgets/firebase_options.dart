// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_-o4__oCWytHL7mXY3XmvafzbQvEtaZc',
    appId: '1:488347209769:web:bb9414e638e073d8fccc38',
    messagingSenderId: '488347209769',
    projectId: 'matchpoint-20eb8',
    authDomain: 'matchpoint-20eb8.firebaseapp.com',
    storageBucket: 'matchpoint-20eb8.firebasestorage.app',
    measurementId: 'G-B20ES6KE3Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKzlYNBM_vBKvSc9E7wjw_sKl7MHPZQb0',
    appId: '1:488347209769:android:b5e6076160193f27fccc38',
    messagingSenderId: '488347209769',
    projectId: 'matchpoint-20eb8',
    storageBucket: 'matchpoint-20eb8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOcMsKj9EhDohohKgVpiril_h4t9YHWhY',
    appId: '1:488347209769:ios:9fcc0d806b4f5313fccc38',
    messagingSenderId: '488347209769',
    projectId: 'matchpoint-20eb8',
    storageBucket: 'matchpoint-20eb8.firebasestorage.app',
    iosBundleId: 'com.example.matchpoint',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOcMsKj9EhDohohKgVpiril_h4t9YHWhY',
    appId: '1:488347209769:ios:9fcc0d806b4f5313fccc38',
    messagingSenderId: '488347209769',
    projectId: 'matchpoint-20eb8',
    storageBucket: 'matchpoint-20eb8.firebasestorage.app',
    iosBundleId: 'com.example.matchpoint',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_-o4__oCWytHL7mXY3XmvafzbQvEtaZc',
    appId: '1:488347209769:web:e1212ed12a2f01e5fccc38',
    messagingSenderId: '488347209769',
    projectId: 'matchpoint-20eb8',
    authDomain: 'matchpoint-20eb8.firebaseapp.com',
    storageBucket: 'matchpoint-20eb8.firebasestorage.app',
    measurementId: 'G-YC1XTL877M',
  );
}
