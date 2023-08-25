import 'package:app/Provider/future_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/Provider/notify_provider.dart';

Future openDialog(
        {required BuildContext context,
        required WidgetRef ref,
        required Todo todo,
        required bool edit}) =>
    dialog(context: context, todo: todo, edit: edit, ref: ref);

Future<dynamic> dialog(
    {required BuildContext context,
    required Todo todo,
    required bool edit,
    required WidgetRef ref}) {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  title.text = todo.todo;
  description.text = todo.description;
  String originalTitle = todo.todo;
  String origianlDescrition = todo.description;
  Todo newTodo = todo;

  final todos = ref.watch(futureTodoListProvider);
  final todoState = ref.watch(futureTodoListProvider.notifier);
  return todos.when(
    data: (todoList) => showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text("Enter Todo"),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  newTodo.todo = title.text;
                },
                onEditingComplete: () {
                  newTodo.todo = title.text;
                },
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Enter Todo",
                ),
                controller: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  newTodo.description = description.text;
                },
                onEditingComplete: () {
                  newTodo.description = description.text;
                },
                decoration: const InputDecoration(
                  hintText: "Enter Description",
                ),
                controller: description,
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {
                title.clear();
                description.clear();
                todo.todo = originalTitle;
                todo.description = origianlDescrition;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
              label: const Text("cancel")),
          TextButton.icon(
              onPressed: () {
                if (title.text != "" && description.text != "") {
                  if (edit) {
                    todoState.editTodo(newTodo);
                  } else {
                    todoState.addTodo(newTodo);
                  }
                  title.clear();
                  description.clear();
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.send),
              label: const Text("Submit"))
        ],
      ),
    ),
    error: (error, stackTrace) => showDialog(
      context: context,
      builder: (context) => Text(error.toString()),
    ),
    loading: () => showDialog(
        context: context,
        builder: (context) =>
            const Center(child: CircularProgressIndicator.adaptive())),
  );
}
