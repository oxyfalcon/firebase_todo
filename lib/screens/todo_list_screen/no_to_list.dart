import 'package:flutter/material.dart';

class NoTodoList extends StatelessWidget {
  const NoTodoList({
    super.key,
  });

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