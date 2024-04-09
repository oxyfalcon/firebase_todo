import 'package:app/Provider/future_provider.dart';
import 'package:app/auth_gate.dart';
import 'package:app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await Config().initialzeApp();
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
