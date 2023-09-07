import 'dart:async';
import 'dart:io';
import 'package:app/Provider/notify_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final userProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.userChanges());

class ProfileNotifier extends AsyncNotifier<String> {
  User? user;

  @override
  String build() {
    print("ProfileProvider --------------");
    user = ref.watch(userProvider).value;
    String ?temp = user?.photoURL;
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
        user!.updatePhotoURL(storageUrl);
        return storageUrl;
      });
    }
  }
}

final profileUrlProvider =
    AsyncNotifierProvider<ProfileNotifier, String>(
        () => ProfileNotifier());

class FutureTodoListNotifier extends AsyncNotifier<List<Todo>> {
  var db = FirebaseFirestore.instance;
  User? user;

  @override
  Future<List<Todo>> build() {
    print("FutureProvider build ---------------------");
    user = ref.watch(userProvider).value;
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
    AsyncNotifierProvider<FutureTodoListNotifier, List<Todo>>(
        () => FutureTodoListNotifier());
