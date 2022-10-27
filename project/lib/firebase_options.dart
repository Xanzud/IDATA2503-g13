import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
/// Default [FirebaseOptions] for use with your Firebase apps.
///
///
///

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
    apiKey: "AIzaSyDU9r_MP_X9HaRRQ2QWru6kqZFmRfJqfgE",
    authDomain: "prepactive-fd5ba.firebaseapp.com",
    projectId: "prepactive-fd5ba",
    storageBucket: "prepactive-fd5ba.appspot.com",
    messagingSenderId: "1026957749869",
    appId: "1:1026957749869:web:d2f83ee48b39b221cbd964",
    measurementId: "G-LH4SDXCTWV"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDprP7E_Bqda5R7bf_RqS8uaaV_Vr8JcM8',
    appId: '1:1026957749869:android:29e43b5c1e3b3289cbd964',
    messagingSenderId: '1026957749869',
    projectId: 'prepactive-fd5ba',
    storageBucket: 'com.g13.prepactive',
  );


  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDU9r_MP_X9HaRRQ2QWru6kqZFmRfJqfgE',
    appId: '1:970341220498:ios:d0f6148f88f09507c2a64b',
    messagingSenderId: '970341220498',
    projectId: 'mobile-e8',
    storageBucket: 'mobile-e8.appspot.com',
    iosClientId: '970341220498-ane8vfavfmifda5i97b0378os7e8amjn.apps.googleusercontent.com',
    iosBundleId: 'no.ntnu.exerciseE8',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDU9r_MP_X9HaRRQ2QWru6kqZFmRfJqfgE',
    appId: '1:970341220498:ios:d0f6148f88f09507c2a64b',
    messagingSenderId: '970341220498',
    projectId: 'mobile-e8',
    storageBucket: 'mobile-e8.appspot.com',
    iosClientId: '970341220498-ane8vfavfmifda5i97b0378os7e8amjn.apps.googleusercontent.com',
    iosBundleId: 'no.ntnu.exerciseE8',
  );

  //TODO SETUP IOS AND MACOS TO MATCH, ONLY WORKING FOR ANDROID AND WEB ATM.
}