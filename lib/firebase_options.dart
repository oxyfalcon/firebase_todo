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
    apiKey: 'AIzaSyBCfF9pFSls2Sh0Z5OJ8BkjDUymytMM5WI',
    appId: '1:589767727505:web:a183995408602e74dd6230',
    messagingSenderId: '589767727505',
    projectId: 'todo-list-ec223',
    authDomain: 'todo-list-ec223.firebaseapp.com',
    storageBucket: 'todo-list-ec223.appspot.com',
    measurementId: 'G-D9W2JC4WQZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAY_-9r5pHnA3VpXJFnr__Yqd4BoSzto2M',
    appId: '1:589767727505:android:427bf9cf7888c3a6dd6230',
    messagingSenderId: '589767727505',
    projectId: 'todo-list-ec223',
    storageBucket: 'todo-list-ec223.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfIz9zxmOleQIa9AJ3rLrXHv93e5Vh8xw',
    appId: '1:589767727505:ios:31a8604fad58e579dd6230',
    messagingSenderId: '589767727505',
    projectId: 'todo-list-ec223',
    storageBucket: 'todo-list-ec223.appspot.com',
    iosBundleId: 'com.example.firebaseTodo',
  );
}
