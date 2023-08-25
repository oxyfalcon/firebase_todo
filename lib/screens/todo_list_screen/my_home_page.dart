import 'package:app/Provider/notify_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchPage = ref.watch(pageDeciderProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text("Todo"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: watchPage,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
