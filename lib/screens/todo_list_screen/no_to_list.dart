import 'package:app/button/main_buttons/add_button.dart';
import 'package:flutter/material.dart';

class NoToDoList extends StatelessWidget {
  const NoToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: FittedBox(
                      child: Text("No Todo",
                          style: Theme.of(context).textTheme.labelLarge)),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.all(20.0),
            child: const AddButton(),
          )
        ],
      ),
    );
  }
}
