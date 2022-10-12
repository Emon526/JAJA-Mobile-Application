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
    apiKey: 'AIzaSyCHQOsqlPZ_keII4hF9bEHCk3fskwhGK-4',
    appId: '1:303909345121:web:998866c785facb3d479720',
    messagingSenderId: '303909345121',
    projectId: 'jaja-79a0d',
    authDomain: 'jaja-79a0d.firebaseapp.com',
    databaseURL: 'https://jaja-79a0d-default-rtdb.firebaseio.com',
    storageBucket: 'jaja-79a0d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUm_ka3zzp1sdq_tkvRnP47Pa7yLYlUCA',
    appId: '1:303909345121:android:48f9107b9c1aa843479720',
    messagingSenderId: '303909345121',
    projectId: 'jaja-79a0d',
    databaseURL: 'https://jaja-79a0d-default-rtdb.firebaseio.com',
    storageBucket: 'jaja-79a0d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAemSDXYfqp7Co9td5SQrSaPcMLqdchK5Q',
    appId: '1:303909345121:ios:4177875306a3a471479720',
    messagingSenderId: '303909345121',
    projectId: 'jaja-79a0d',
    databaseURL: 'https://jaja-79a0d-default-rtdb.firebaseio.com',
    storageBucket: 'jaja-79a0d.appspot.com',
    iosClientId: '303909345121-qeaivtip89fk7ue782gl0mddrpkjf53v.apps.googleusercontent.com',
    iosBundleId: 'com.example.jaja',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAemSDXYfqp7Co9td5SQrSaPcMLqdchK5Q',
    appId: '1:303909345121:ios:4177875306a3a471479720',
    messagingSenderId: '303909345121',
    projectId: 'jaja-79a0d',
    databaseURL: 'https://jaja-79a0d-default-rtdb.firebaseio.com',
    storageBucket: 'jaja-79a0d.appspot.com',
    iosClientId: '303909345121-qeaivtip89fk7ue782gl0mddrpkjf53v.apps.googleusercontent.com',
    iosBundleId: 'com.example.jaja',
  );
}