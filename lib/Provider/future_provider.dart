import 'package:app/Provider/notify_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FutureTodoListNotifier extends AsyncNotifier<List<Todo>> {
  var db = FirebaseFirestore.instance;
  void name() {
    db.settings = const Settings(persistenceEnabled: true);
  }

  Future<List<Todo>> _fetchTodoFirebase() async {
    var x = await db.collection('users').get();
    List<Todo> list = [];
    x.docs.map((e) => list.add(Todo.fromJson(e.data()))).toList();
    return list;
  }

  Future<void> fetch() async =>
      state = await AsyncValue.guard(() => _fetchTodoFirebase());

  @override
  Future<List<Todo>> build() => _fetchTodoFirebase();

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
      db.collection('users').doc(t.id).set(body);
      return _fetchTodoFirebase();
    });
  }

  Future<void> deleteTodo(Todo t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      String id = t.id;
      db.collection('users').doc(id).delete();
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
      db.collection('users').doc(edited.id).set(body);
      return _fetchTodoFirebase();
    });
  }

  Future<void> markedChange({required Todo itr, required bool change}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await db.collection("users").doc(itr.id).update({'is_completed': change});
      return _fetchTodoFirebase();
    });
  }
}

final futureTodoListProvider =
    AsyncNotifierProvider<FutureTodoListNotifier, List<Todo>>(
        () => FutureTodoListNotifier());
