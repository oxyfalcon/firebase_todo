import 'package:app/Provider/future_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var profileUrl = ref.watch(profileUrlProvider);
    ProfileNotifier profileNotifier = ref.read(profileUrlProvider.notifier);
    Brightness currentBrightness = ref.read(brightnessProvider);
    bool currentValue = (currentBrightness == Brightness.dark) ? true : false;
    BrightnessNotifier brightnessNotifier =
        ref.read(brightnessProvider.notifier);
    String text = (currentValue) ? "light mode" : "dark mode";
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                  child: InkWell(
                      onTap: () => profileNotifier.uploadFile(),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: profileUrl.when(
                            data: (url) => CustomUserAvatar(url: url),
                            error: (error, stacktrace) =>
                                Text(error.toString()),
                            loading: () => const CircularProgressIndicator()),
                      ))),
              const Align(child: EditableUserDisplayName()),
              Align(
                child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "${FirebaseAuth.instance.currentUser?.email}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Change to $text"),
                  Switch.adaptive(
                      value: currentValue,
                      onChanged: (value) {
                        currentValue = value;
                        brightnessNotifier.changeBrightness(value);
                      }),
                ],
              )
            ],
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
            ? FutureBuilder(
                future: ref
                    .watch(profileUrlProvider.notifier)
                    .cacheLastUpdate(false, url),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: url,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
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

class CustomCacheManager {
  static String key = 'cache2';
  static CacheManager instance = CacheManager(Config(
    key,
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 20,
  ));
}
