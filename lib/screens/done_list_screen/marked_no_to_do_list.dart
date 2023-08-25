import 'package:flutter/material.dart';

class MarkedNoTodoList extends StatelessWidget {
  const MarkedNoTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondaryContainer,
      body: Stack(
        children: <Widget>[
          Center(
            child: FittedBox(
                child:
                    Text("No Marked Todo", style: theme.textTheme.labelLarge)),
          ),
        ],
      ),
    );
  }
}
