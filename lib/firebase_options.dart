// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBAy_ij5R1nIvyMO6nf3n_cB-rOj15S3Og',
    appId: '1:1015138798558:web:323327d607ffd0d392ab4f',
    messagingSenderId: '1015138798558',
    projectId: 'furniverse-5f170',
    authDomain: 'furniverse-5f170.firebaseapp.com',
    storageBucket: 'furniverse-5f170.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7YHZIEunyGMkywcqDMbqmme9gyecIUtI',
    appId: '1:1015138798558:android:bc8a4ed76ab2af5192ab4f',
    messagingSenderId: '1015138798558',
    projectId: 'furniverse-5f170',
    storageBucket: 'furniverse-5f170.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBlA99Xe46ylDQgLUO5Nq6o9GC57DRtuPE',
    appId: '1:1015138798558:ios:309ecc9ef708f09292ab4f',
    messagingSenderId: '1015138798558',
    projectId: 'furniverse-5f170',
    storageBucket: 'furniverse-5f170.appspot.com',
    iosBundleId: 'com.example.furniverseAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBlA99Xe46ylDQgLUO5Nq6o9GC57DRtuPE',
    appId: '1:1015138798558:ios:b2fdb9e076491c7692ab4f',
    messagingSenderId: '1015138798558',
    projectId: 'furniverse-5f170',
    storageBucket: 'furniverse-5f170.appspot.com',
    iosBundleId: 'com.example.furniverseAdmin.RunnerTests',
  );
}
