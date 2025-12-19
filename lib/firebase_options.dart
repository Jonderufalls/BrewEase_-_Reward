import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAV2-cvowA4zPLX0E8qYhMjPtx_TGAZEFQ",
    authDomain: "brewease-62dcf.firebaseapp.com",
    projectId: "brewease-62dcf",
    storageBucket: "brewease-62dcf.firebasestorage.app",
    messagingSenderId: "268315260464",
    appId: "1:268315260464:web:1333f1dd822421c28d9ff5",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAV2-cvowA4zPLX0E8qYhMjPtx_TGAZEFQ",
    appId: "1:268315260464:android:1333f1dd822421c2",
    messagingSenderId: "268315260464",
    projectId: "brewease-62dcf",
    storageBucket: "brewease-62dcf.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAV2-cvowA4zPLX0E8qYhMjPtx_TGAZEFQ",
    appId: "1:268315260464:ios:1333f1dd822421c28d9ff5",
    messagingSenderId: "268315260464",
    projectId: "brewease-62dcf",
    storageBucket: "brewease-62dcf.firebasestorage.app",
    iosBundleId: "com.example.brewease",
  );
}
