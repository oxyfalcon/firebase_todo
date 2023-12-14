import 'package:flutter/material.dart';

class NoTodoList extends StatefulWidget {
  const NoTodoList({
    super.key,
  });

  @override
  State<NoTodoList> createState() => _NoTodoListState();
}

class _NoTodoListState extends State<NoTodoList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: const Text("No Todo"),
        )
      ],
    );
  }
}
