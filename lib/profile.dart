import 'package:app/Provider/future_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

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
            child: Consumer(builder: (context, ref, child) {
              var profileUrl = ref.watch(profileUrlProvider);
              ProfileNotifier profileNotifier =
                  ref.watch(profileUrlProvider.notifier);
              return InkWell(
                  onTap: () {
                    profileNotifier.uploadFile();
                  },
                  child: profileUrl.when(
                      data: (url) => CustomUserAvatar(url: url),
                      error: (error, stacktrace) =>
                          const Text("Could not do it"),
                      loading: () => const CircularProgressIndicator()));
            }),
          ),
          const Align(child: EditableUserDisplayName()),
          Align(
            child: Consumer(
                builder: (context, ref, child) => Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "${ref.read(userProvider).value!.email}",
                      style: const TextStyle(fontSize: 20),
                    ))),
          ),
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
          ),
        ],
      ),
    );
  }
}

class CustomRedColor extends MaterialStateProperty<Color> {
  @override
  Color resolve(Set<MaterialState> states) => Colors.red;
}

class CustomUserAvatar extends ConsumerWidget {
  const CustomUserAvatar({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double size = 100;
    return SizedBox(
      height: size,
      width: size,
      child: ClipPath(
        clipper: const ShapeBorderClipper(shape: CircleBorder()),
        clipBehavior: Clip.hardEdge,
        child: url != ""
            ? Image.network(
                url,
                width: size,
                height: size,
                cacheWidth: size.toInt(),
                cacheHeight: size.toInt(),
                fit: BoxFit.cover,
              )
            : Center(
                child: Icon(
                  Icons.account_circle,
                  size: size,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
