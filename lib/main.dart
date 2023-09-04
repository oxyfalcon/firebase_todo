import 'package:app/auth_date.dart';
import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import 'my_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const AuthGate(),
          title: "Todo",
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
            useMaterial3: true,
          )),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
      if(!snapshot.hasData){
        return SignInScreen(
          providerConfigs: const [
            EmailProviderConfiguration()
          ],
          headerBuilder: (context, constraints, shrinkOffset) => Image.asset("Images/flutterfire_300x.png"),
        );
      }
      return const MyHomePage();
    });
  }
}