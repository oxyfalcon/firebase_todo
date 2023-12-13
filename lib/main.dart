import 'package:app/Provider/future_provider.dart';
import 'package:app/auth_gate.dart';
import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  _isolateMain(rootIsolateToken);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return runApp(const ProviderScope(child: MyApp()));
}

void _isolateMain(RootIsolateToken rootIsolateToken) async =>
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: getApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return FirebaseApp(child: Text(snapshot.error.toString()));
          }
          return (snapshot.connectionState == ConnectionState.done)
              ? const FirebaseApp(
                  child: AuthGate(),
                )
              : const FirebaseApp(child: CircularProgressIndicator());
        });
  }

  Future<void> getApp() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  }
}

class FirebaseApp extends ConsumerWidget {
  const FirebaseApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
        title: "Todo",
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: ref.watch(brightnessProvider),
          ),
        ),
      ),
    );
  }
}
