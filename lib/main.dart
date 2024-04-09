import 'package:app/Provider/future_provider.dart';
import 'package:app/auth_gate.dart';
import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  return runApp(const ProviderScope(child: FirebaseApp(child: AuthGate())));
}

class FirebaseApp extends ConsumerWidget {
  const FirebaseApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: child,
      title: "Todo",
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: ref.watch(brightnessProvider),
        ),
      ),
    );
  }
}
