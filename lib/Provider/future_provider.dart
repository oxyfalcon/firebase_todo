import 'dart:async';
import 'dart:io';
import 'package:app/Provider/todo_schema.dart';
import 'package:app/config.dart';
import 'package:app/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileNotifier extends AutoDisposeAsyncNotifier<String> {
  User? user;

  @override
  Future<String> build() async {
    user = FirebaseAuth.instance.currentUser;
    String? temp = user?.photoURL;
    String authPhotoUrl = (temp == null) ? "" : temp;
    return authPhotoUrl;
  }

  Future<void> uploadFile() async {
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
        user?.updatePhotoURL(storageUrl);
        return storageUrl;
      });
    }
  }

  Future<void> cacheLastUpdate(bool cache, String url) async {
    if (!cache) {
      PaintingBinding.instance.imageCache.clear();
      return await CustomCacheManager.instance.emptyCache();
    }
  }
}

final profileUrlProvider =
    AutoDisposeAsyncNotifierProvider<ProfileNotifier, String>(
        () => ProfileNotifier());

class FutureTodoListNotifier extends AutoDisposeAsyncNotifier<List<Todo>> {
  var db = FirebaseFirestore.instance;
  User? user;
  late List<Todo> list;
  late ItemsNotifier _itemsNotifier;

  @override
  Future<List<Todo>> build() async {
    user = FirebaseAuth.instance.currentUser;
    db.settings = const Settings(persistenceEnabled: true);
    list = await _fetchTodoFirebase();
    return list;
  }

  Future<List<Todo>> _fetchTodoFirebase() async {
    var x = await db.collection(user!.uid).get();
    List<Todo> temp = [];
    x.docs.map((e) => temp.add(Todo.fromJson(e.data()))).toList();
    _itemsNotifier = ref.watch(itemsProvider(temp).notifier);
    list = temp;
    return temp;
  }

  Future<void> fetch() async =>
      state = await AsyncValue.guard(() => _fetchTodoFirebase());

  Future<void> addTodo(Todo t) async {
    _itemsNotifier.addTodo(t);
    await AsyncValue.guard(() async {
      var id = db.collection('users').doc().id;
      var body = {
        "title": t.todo,
        "description": t.description,
        "is_completed": t.isCompleted,
        "_id": id
      };
      t.id = id;
      await db.collection(user!.uid).doc(t.id).set(body);
    });
  }

  Future<void> deleteTodo(Todo t) async {
    _itemsNotifier.deleteTodo(t);
    await db.collection(user!.uid).doc(t.id).delete();
  }

  Future<void> editTodo(Todo edited) async {
    _itemsNotifier.edit(edited);
    await AsyncValue.guard(() async {
      Map<String, dynamic> body = {
        "title": edited.todo,
        "description": edited.description,
        "is_completed": edited.isCompleted,
        "_id": edited.id
      };
      await db.collection(user!.uid).doc(edited.id).set(body);
    });
  }

  Future<void> markedChange({required Todo itr, required bool change}) async {
    _itemsNotifier.markedChange(itr: itr, change: change);
    await db.collection(user!.uid).doc(itr.id).update({'is_completed': change});
  }

  Future<void> markedDelete({required Todo itr}) async {
    _itemsNotifier.markedDelete(itr: itr);
    await db.collection(user!.uid).doc(itr.id).update({'is_completed': false});
  }
}

final futureTodoListProvider =
    AutoDisposeAsyncNotifierProvider<FutureTodoListNotifier, List<Todo>>(
        () => FutureTodoListNotifier());

class ItemsNotifier extends AutoDisposeFamilyNotifier<List<Todo>, List<Todo>> {
  @override
  List<Todo> build(List<Todo> arg) => arg;

  void markedChange({required Todo itr, required bool change}) {
    for (var i in state) {
      if (i.id == itr.id) {
        i.isCompleted = change;
      }
    }
  }

  void changeList({required List<Todo> newList}) =>
      state = List<Todo>.from(newList);

  void markedDelete({required Todo itr}) =>
      state = List<Todo>.from(state.where((element) {
        if (element.id == itr.id) {
          element.isCompleted = false;
        }
        return true;
      }));

  void addTodo(Todo t) => state = [...state, t];

  void deleteTodo(Todo t) => state = List<Todo>.from(
      state.where((element) => (element.id == t.id) ? false : true));

  void edit(Todo edited) => state = List<Todo>.from(state.where((element) {
        if (element.id == edited.id) {
          element = edited;
        }
        return true;
      }));
}

class BrightnessNotifier extends AutoDisposeNotifier<Brightness>
    with WidgetsBindingObserver {
  @override
  void didChangePlatformBrightness() {
    WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark
        ? setDark()
        : setLight();
    super.didChangePlatformBrightness();
  }

  @override
  Brightness build() {
    bool? isDark = Config().pref.getBool("isDark");
    WidgetsBinding.instance.addObserver(this);
    if (isDark == null) {
      Brightness brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      brightness == Brightness.dark
          ? Config().pref.setBool("isDark", true)
          : Config().pref.setBool("isDark", false);
      return brightness;
    } else {
      return isDark ? Brightness.dark : Brightness.light;
    }
  }

  Future<void> setDark() async {
    state = Brightness.dark;
    await Config().pref.setBool("isDark", true);
  }

  Future<void> setLight() async {
    state = Brightness.light;
    await Config().pref.setBool("isDark", false);
  }
}

final brightnessProvider =
    AutoDisposeNotifierProvider<BrightnessNotifier, Brightness>(
        () => BrightnessNotifier());

final itemsProvider =
    AutoDisposeNotifierProviderFamily<ItemsNotifier, List<Todo>, List<Todo>>(
        ItemsNotifier.new);
