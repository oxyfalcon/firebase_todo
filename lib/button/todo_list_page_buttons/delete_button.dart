import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/todo_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({
    super.key,
    required this.todoState,
    required this.itr,
  });

  final FutureTodoListNotifier todoState;
  final Todo itr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton.filled(
      color: Theme.of(context).cardColor,
      onPressed: () {
        ref.read(futureTodoListProvider.notifier).deleteTodo(itr);
      },
      icon: const Icon(Icons.delete),
    );
  }
}
