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
    apiKey: 'AIzaSyD9qSPgAg481C6kAP19B8qAaIdx74q4FdE',
    appId: '1:674271699276:android:73a5e238835be77a3fefe9',
    messagingSenderId: '674271699276',
    projectId: 'iotpro-10694',
    databaseURL: 'https://iotpro-10694-default-rtdb.firebaseio.com',
    storageBucket: 'iotpro-10694.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_6z48tOneU3WIuhWwe9zqLw7PfMldKIc',
    appId: '1:674271699276:ios:553752388391f9153fefe9',
    messagingSenderId: '674271699276',
    projectId: 'iotpro-10694',
    databaseURL: 'https://iotpro-10694-default-rtdb.firebaseio.com',
    storageBucket: 'iotpro-10694.appspot.com',
    androidClientId: '674271699276-3hn6jpdnv6jpdde6s78jo144tu998q4s.apps.googleusercontent.com',
    iosBundleId: 'com.example.officer',
  );
}