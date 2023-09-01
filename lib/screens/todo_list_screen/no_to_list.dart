import 'package:app/button/main_buttons/add_button.dart';
import 'package:flutter/material.dart';

class NoToDoList extends StatelessWidget {
  const NoToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondaryContainer,
      body: Stack(
        children: [
          Center(
            child: FittedBox(
                child: Text("No Todo", style: theme.textTheme.labelLarge)),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: AddButton()),
        ],
      ),
    );
  }
}
