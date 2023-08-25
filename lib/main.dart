import 'package:app/screens/todo_list_screen/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
          title: "Todo",
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
            useMaterial3: true,
          )),
    );
  }
}
