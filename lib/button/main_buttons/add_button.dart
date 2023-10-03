import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/todo_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/screens/dialog_input_screen/popup_input.dart';

class AddButton extends ConsumerWidget {
  const AddButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      onPressed: (() {
        openDialog(
            context: context,
            futureTodoListNotifier: ref.read(futureTodoListProvider.notifier),
            todo: Todo.empty(),
            edit: false);
      }),
      child: const Icon(Icons.add),
    );
  }
}
