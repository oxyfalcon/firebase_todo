import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            child: UserAvatar(
              auth: FirebaseAuth.instance,
            ),
          ),
          const Align(child: EditableUserDisplayName()),
          Container(
            margin: const EdgeInsets.all(10),
            child: FilledButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.exit_to_app),
                        ),
                        Text("Logout"),
                      ],
                    ))),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FilledButton(
                onPressed: () {
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

class CustomRedColor extends MaterialStateProperty<Color> {
  @override
  Color resolve(Set<MaterialState> states) => Colors.red;
}

// class ProfilePicture extends StatefulWidget {
//   const ProfilePicture({super.key});
//
//   @override
//   State<ProfilePicture> createState() => _ProfilePictureState();
// }
//
// class _ProfilePictureState extends State<ProfilePicture> {
//   final storageRef = FirebaseStorage.instance.ref();
//   Future<void> _getFile() async{
//     final result = await FilePicker.platform.pickFiles();
//     final path = File()
//   }
//
//   Future<void> _uploadFile() async{
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
