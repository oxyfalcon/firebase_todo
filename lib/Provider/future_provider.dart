import 'dart:async';
import 'dart:io';
import 'package:app/Provider/todo_schema.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

final userProvider = AutoDisposeStreamProvider<User?>(
    (ref) => FirebaseAuth.instance.authStateChanges());

class ProfileNotifier extends AutoDisposeAsyncNotifier<String> {
  @override
  Future<String> build() async {
    print("profile builder --------------------");
    String? temp =
        await ref.watch(userProvider.selectAsync((data) => data?.photoURL));
    String authPhotoUrl = (temp == null) ? "" : temp;
    return authPhotoUrl;
  }

  Future<void> uploadFile() async {
    User? user = ref.read(userProvider).value;
    ImagePicker pickImage = ImagePicker();
    final result2 = await pickImage.pickImage(source: ImageSource.gallery);
    if (result2 != null) {
      File file = File(result2.path);
      var storage =
          FirebaseStorage.instance.ref().child("${user!.uid}/profile.png");
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        await storage.putFile(file);
        String storageUrl = await storage.getDownloadURL();
        user.updatePhotoURL(storageUrl);
        return storageUrl;
      });
    }
  }
}

final profileUrlProvider =
    AutoDisposeAsyncNotifierProvider<ProfileNotifier, String>(
        () => ProfileNotifier());

class FutureTodoListNotifier extends AutoDisposeAsyncNotifier<List<Todo>> {
  var db = FirebaseFirestore.instance;
  User? user;

  @override
  Future<List<Todo>> build() async {
    print("FutureTodo builder --------------------");
    user = await ref.watch(userProvider.selectAsync((data) => data));
    db.settings = const Settings(persistenceEnabled: true);
    return _fetchTodoFirebase();
  }

  Future<List<Todo>> _fetchTodoFirebase() async {
    var x = await db.collection(user!.uid).get();
    List<Todo> list = [];
    x.docs.map((e) => list.add(Todo.fromJson(e.data()))).toList();
    return list;
  }

  Future<void> fetch() async => state = await AsyncValue.guard(() {
        return _fetchTodoFirebase();
      });

  void addTodo(Todo t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var id = db.collection('users').doc().id;
      var body = {
        "title": t.todo,
        "description": t.description,
        "is_completed": t.isCompleted,
        "_id": id
      };
      t.id = id;
      db.collection(user!.uid).doc(t.id).set(body);
      return _fetchTodoFirebase();
    });
  }

  Future<void> deleteTodo(Todo t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      String id = t.id;
      db.collection(user!.uid).doc(id).delete();
      return _fetchTodoFirebase();
    });
  }

  Future<void> editTodo(Todo edited) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      Map<String, dynamic> body = {
        "title": edited.todo,
        "description": edited.description,
        "is_completed": edited.isCompleted,
        "_id": edited.id
      };
      db.collection(user!.uid).doc(edited.id).set(body);
      return _fetchTodoFirebase();
    });
  }

  Future<void> markedChange({required Todo itr, required bool change}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await db
          .collection(user!.uid)
          .doc(itr.id)
          .update({'is_completed': change});
      return _fetchTodoFirebase();
    });
  }
}

final futureTodoListProvider =
    AutoDisposeAsyncNotifierProvider<FutureTodoListNotifier, List<Todo>>(
        () => FutureTodoListNotifier());

class BrightnessNotifier extends AutoDisposeNotifier<Brightness>
    with WidgetsBindingObserver {
  // Brightness currentBrightness =
  //      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  // late bool isDarkMode;

  // void setMemory(bool value) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setBool(DarkMode.isDark.name, value);
  // }

  // Future<bool> getMemory() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   return (pref.containsKey(DarkMode.isDark.name))
  //       ? false
  //       : pref.getBool(DarkMode.isDark.name) ??
  //               (currentBrightness == Brightness.dark)
  //           ? true
  //           : false;
  // }

  @override
  void didChangePlatformBrightness() {
    state = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    super.didChangePlatformBrightness();
  }

  @override
  Brightness build() {
    WidgetsBinding.instance.addObserver(this);
    // isDarkMode = await getMemory();
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  void changeBrightness(bool value) {
    state = (value) ? Brightness.dark : Brightness.light;
    // setMemory(value);
  }
}

final brightnessProvider =
    AutoDisposeNotifierProvider<BrightnessNotifier, Brightness>(
        () => BrightnessNotifier());

enum DarkMode { isDark, isDefault }
