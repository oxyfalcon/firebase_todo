import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        centerTitle: true,
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${FirebaseAuth.instance.currentUser?.email}", textAlign: TextAlign.center,),
          TextButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          }, child: Container(margin: const EdgeInsets.all(10), child: const Text("Logout"))),
          Container(
            margin: const EdgeInsets.all(10),
            child: FilledButton(onPressed: () {
              FirebaseAuth.instance.currentUser!.delete();
              Navigator.pop(context);
            },
                style: ButtonStyle(backgroundColor: CustomRedColor()),
                child: const Text("Delete Account")),
          )
        ],
      ),
    );
  }
}

class CustomRedColor extends MaterialStateProperty<Color>{
  @override
  Color resolve(Set<MaterialState> states) {
    return Colors.red;
  }
}
