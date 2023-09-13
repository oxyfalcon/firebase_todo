import 'package:app/Provider/future_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/Provider/todo_schema.dart';

Future openDialog(
        {required BuildContext context,
        required Todo todo,
        required bool edit,
        required FutureTodoListNotifier futureTodoListNotifier}) =>
    dialog(
        context: context,
        edit: edit,
        todo: todo,
        futureTodoListNotifier: futureTodoListNotifier);

Future<dynamic> dialog(
    {required BuildContext context,
    required Todo todo,
    required bool edit,
    required FutureTodoListNotifier futureTodoListNotifier}) {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  title.text = todo.todo;
  description.text = todo.description;
  String originalTitle = todo.todo;
  String originalDescription = todo.description;
  Todo newTodo = todo;

  (String, String) text(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    (String, String) allCaps = ("CANCEL", "SUBMIT");
    (String, String) captizedWords = ("Cancel", "Submit");

    switch (platform) {
      case TargetPlatform.iOS:
        return allCaps;
      case TargetPlatform.macOS:
        return allCaps;
      default:
        return captizedWords;
    }
  }

  return showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog.adaptive(
            title: const Text("Enter Todo"),
            content: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: true,
                    onChanged: (value) {
                      newTodo.todo = title.text;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Todo",
                    ),
                    controller: title,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      newTodo.description = description.text;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Description",
                    ),
                    controller: description,
                  ),
                ),
              ],
            ),
            actions: [
              AdaptiveDialog(
                onPressed: () {
                  title.clear();
                  description.clear();
                  todo.todo = originalTitle;
                  todo.description = originalDescription;
                  Navigator.of(context).pop();
                },
                child: Text(text(context).$1),
              ),
              AdaptiveDialog(
                  onPressed: () {
                    if (title.text != "" && description.text != "") {
                      (edit)
                          ? futureTodoListNotifier.editTodo(newTodo)
                          : futureTodoListNotifier.addTodo(newTodo);

                      title.clear();
                      description.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(text(context).$2)),
            ],
          ),
        );
      });
}

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog(
      {super.key, required this.onPressed, required this.child});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.iOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
      default:
        return TextButton(onPressed: onPressed, child: child);
    }
  }
}
