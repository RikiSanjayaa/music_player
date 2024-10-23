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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBNxb5D8Z9gYplJa-50PUHY-gdBd3h7ShI',
    appId: '1:749137375569:web:ae283b2d619573c4bb6370',
    messagingSenderId: '749137375569',
    projectId: 'music-p-eb894',
    authDomain: 'music-p-eb894.firebaseapp.com',
    storageBucket: 'music-p-eb894.appspot.com',
    measurementId: 'G-MXR5ZP0WR8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOJagqRzH0e31vzlUdPTbFTN0vwddmcxg',
    appId: '1:749137375569:android:52469f500febdfedbb6370',
    messagingSenderId: '749137375569',
    projectId: 'music-p-eb894',
    storageBucket: 'music-p-eb894.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxm1yfRn2FHVV1KBzqL_tWJ0AWRQ6wHCM',
    appId: '1:749137375569:ios:2a77ae0824d9bd0abb6370',
    messagingSenderId: '749137375569',
    projectId: 'music-p-eb894',
    storageBucket: 'music-p-eb894.appspot.com',
    iosBundleId: 'com.example.musicPlayer',
  );
}
