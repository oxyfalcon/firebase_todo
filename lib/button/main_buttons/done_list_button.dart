import 'package:app/screens/done_list_screen/marked_home_page.dart';
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MarkedHomePage()));
      },
      icon: const Icon(Icons.check),
    );
  }
}
