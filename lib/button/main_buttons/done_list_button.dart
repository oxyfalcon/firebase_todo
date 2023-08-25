import 'package:flutter/material.dart';

class DoneListButton extends StatelessWidget {
  const DoneListButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text("Done"),
      onPressed: () {
        Navigator.pushNamed(context, '/marked');
      },
      icon: const Icon(Icons.check),
    );
  }
}
