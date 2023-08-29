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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD069ed7zKl2iZ74ANc2QY-kgKuLjIuXEU',
    appId: '1:415677405573:android:a70e3fd0b779ff338b0cec',
    messagingSenderId: '415677405573',
    projectId: 'hairandmore-90341',
    storageBucket: 'hairandmore-90341.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUEStLqK_3-duJhdrAKbISespQC4v4wlo',
    appId: '1:415677405573:ios:5cc6cc6a6ee420d28b0cec',
    messagingSenderId: '415677405573',
    projectId: 'hairandmore-90341',
    storageBucket: 'hairandmore-90341.appspot.com',
    androidClientId: '415677405573-5511ektaoirkt98ue8pgjeplrkoogpqh.apps.googleusercontent.com',
    iosClientId: '415677405573-9tsjdsqp570at8iv12gtkofir20kc4uo.apps.googleusercontent.com',
    iosBundleId: 'com.example.hairAndMore',
  );
}