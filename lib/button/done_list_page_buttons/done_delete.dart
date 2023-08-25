import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/notify_provider.dart';
import 'package:flutter/material.dart';

class DoneDeleteButton extends StatelessWidget {
  const DoneDeleteButton({
    super.key,
    required this.todoState,
    required this.itr,
  });

  final FutureTodoListNotifier todoState;
  final Todo itr;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      color: Theme.of(context).cardColor,
      onPressed: () {
        todoState.markedDelete(itr);
      },
      icon: const Icon(Icons.delete),
    );
  }
}
