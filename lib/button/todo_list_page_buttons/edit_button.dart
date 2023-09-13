import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/todo_schema.dart';
import 'package:app/screens/dialog_input_screen/popup_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditButton extends ConsumerWidget {
  const EditButton({
    super.key,
    required this.itr,
  });

  final Todo itr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton.filledTonal(
        onPressed: () {
          openDialog(
              context: context,
              futureTodoListNotifier: ref.read(futureTodoListProvider.notifier),
              todo: itr,
              edit: true);
        },
        highlightColor: Theme.of(context).colorScheme.inversePrimary,
        color: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.edit));
  }
}
