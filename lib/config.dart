import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static final _instance = Config._();
  Config._();
  factory Config() => _instance;
  late final SharedPreferences pref;

  Future<void> initialzeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
    pref = await SharedPreferences.getInstance();
  }
}
