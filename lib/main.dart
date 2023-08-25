import 'package:app/screens/done_list_screen/marked_home_page.dart';
import 'package:app/screens/todo_list_screen/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp(
          home: const MyHomePage(),
          title: "Todo",
          initialRoute: '/',
          routes: {'/marked': (context) => const MarkedHomePage()},
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
            useMaterial3: true,
          )),
    );
  }
}
