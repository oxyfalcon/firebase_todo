import 'package:app/Provider/notify_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/screens/dialog_input_screen/popup_input.dart';

class AddButton extends ConsumerStatefulWidget {
  const AddButton({super.key});

  @override
  ConsumerState<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends ConsumerState<AddButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        label: const Text("add"),
        icon: const Icon(Icons.favorite),
        onPressed: (() {
          openDialog(
              context: context,
              ref: ref,
              todo: Todo(todo: "", description: "", id: ""),
              edit: false);
        }));
  }
}
