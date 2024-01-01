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
    apiKey: 'AIzaSyBD1MC0qNsFUUsRVNxhUSucAaAv0A8uxvo',
    appId: '1:594954301473:web:b27302f481975a52f7f360',
    messagingSenderId: '594954301473',
    projectId: 'study-planning-205cf',
    authDomain: 'study-planning-205cf.firebaseapp.com',
    storageBucket: 'study-planning-205cf.appspot.com',
    measurementId: 'G-FK2XFMEP9C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDgVpae8zkGOW2W5SVVBjlcIx-d7s49Oc',
    appId: '1:594954301473:android:020df323f856d192f7f360',
    messagingSenderId: '594954301473',
    projectId: 'study-planning-205cf',
    storageBucket: 'study-planning-205cf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCtlXGOb4h62cC_gvU-a2H-W2znKbxeTq4',
    appId: '1:594954301473:ios:2544792903bbb578f7f360',
    messagingSenderId: '594954301473',
    projectId: 'study-planning-205cf',
    storageBucket: 'study-planning-205cf.appspot.com',
    iosBundleId: 'com.hypeboy.crossplatform.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCtlXGOb4h62cC_gvU-a2H-W2znKbxeTq4',
    appId: '1:594954301473:ios:1043d6ac69c2b237f7f360',
    messagingSenderId: '594954301473',
    projectId: 'study-planning-205cf',
    storageBucket: 'study-planning-205cf.appspot.com',
    iosBundleId: 'com.hypeboy.crossplatform.frontend.RunnerTests',
  );
}
