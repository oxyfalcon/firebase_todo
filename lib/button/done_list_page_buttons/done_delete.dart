import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/todo_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoneDeleteButton extends ConsumerWidget {
  const DoneDeleteButton({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton.filled(
      color: Theme.of(context).cardColor,
      onPressed: () {
        ref
            .read(futureTodoListProvider.notifier)
            .markedDelete(itr: todo);
      },
      icon: const Icon(Icons.delete),
    );
  }
}
