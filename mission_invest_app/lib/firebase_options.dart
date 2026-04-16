// File generated manually from Firebase project: mission-inverse
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyApTGBBioomfvKfm9UtKpP9OeokKhbFTAg',
    appId: '1:779968530362:web:9b6018a65d094579f23f83',
    messagingSenderId: '779968530362',
    projectId: 'mission-inverse',
    authDomain: 'mission-inverse.firebaseapp.com',
    storageBucket: 'mission-inverse.firebasestorage.app',
    measurementId: 'G-JT0QHW8TR3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGAoOqiWtjsIJBV-XA2eycDMCuXSWc9M4',
    appId: '1:779968530362:android:8ae0460afc1c00e8f23f83',
    messagingSenderId: '779968530362',
    projectId: 'mission-inverse',
    storageBucket: 'mission-inverse.firebasestorage.app',
  );
}
