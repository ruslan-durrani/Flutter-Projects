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
    apiKey: 'AIzaSyAQVDhMqDitWLwHxxJY2KHXUTeNcyVraKc',
    appId: '1:909464891678:web:7eb191f8a544341aab590f',
    messagingSenderId: '909464891678',
    projectId: 'nexus-meet',
    authDomain: 'nexus-meet.firebaseapp.com',
    storageBucket: 'nexus-meet.appspot.com',
    measurementId: 'G-3HPX37MPPW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8JZx_SGkaZWqPjl31H9-aLrSKWwpu1j0',
    appId: '1:909464891678:android:3edeee2268672c2cab590f',
    messagingSenderId: '909464891678',
    projectId: 'nexus-meet',
    storageBucket: 'nexus-meet.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmjzQU77DBSSmQ9usC19t8NRmYUXQQQME',
    appId: '1:909464891678:ios:b2b9da656ea6856eab590f',
    messagingSenderId: '909464891678',
    projectId: 'nexus-meet',
    storageBucket: 'nexus-meet.appspot.com',
    iosClientId: '909464891678-tnfautvfva8ornf27p560sr3jr947k3i.apps.googleusercontent.com',
    iosBundleId: 'com.example.nexusMeet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmjzQU77DBSSmQ9usC19t8NRmYUXQQQME',
    appId: '1:909464891678:ios:b2b9da656ea6856eab590f',
    messagingSenderId: '909464891678',
    projectId: 'nexus-meet',
    storageBucket: 'nexus-meet.appspot.com',
    iosClientId: '909464891678-tnfautvfva8ornf27p560sr3jr947k3i.apps.googleusercontent.com',
    iosBundleId: 'com.example.nexusMeet',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAQVDhMqDitWLwHxxJY2KHXUTeNcyVraKc',
    appId: '1:909464891678:web:4e1fa94db6d8f634ab590f',
    messagingSenderId: '909464891678',
    projectId: 'nexus-meet',
    authDomain: 'nexus-meet.firebaseapp.com',
    storageBucket: 'nexus-meet.appspot.com',
    measurementId: 'G-D8CNRMN937',
  );
}