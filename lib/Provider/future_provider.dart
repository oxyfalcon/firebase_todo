import 'dart:convert';
import 'package:app/Provider/notify_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FutureTodoListNotifier extends AsyncNotifier<List<Todo>> {
  String uri = "https://api.nstack.in/v1/todos";
  var header = {'Content-Type': 'application/json'};
  Future<List<Todo>> _fetchTodo() async {
    final response = await http.get(Uri.parse(uri));
    var json = jsonDecode(response.body)['items'];
    List<Todo> list = [];
    for (var itr in json) {
      list.add(Todo.fromJson(itr));
    }
    return list;
  }

  Future<void> fetch() async {
    state = await AsyncValue.guard(() => _fetchTodo());
  }

  @override
  Future<List<Todo>> build() {
    print("Provider: build");
    return _fetchTodo();
  }

  void addTodo(Todo t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await http.post(Uri.parse("https://api.nstack.in/v1/todos"),
          headers: header,
          body: jsonEncode({
            "title": t.todo,
            "description": t.description,
            "is_completed": t.completed
          }));
      return _fetchTodo();
    });
  }

  Future<void> deleteTodo(Todo t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      String id = t.id;
      http.delete(Uri.parse("https://api.nstack.in/v1/todos/$id"),
          headers: header);
      return _fetchTodo();
    });
  }

  Future<void> editTodo(Todo edited) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      http.put(Uri.parse("https://api.nstack.in/v1/todos/${edited.id}"),
          headers: header,
          body: jsonEncode({
            "title": edited.todo,
            "description": edited.description,
            "is_completed": edited.completed
          }));
      return _fetchTodo();
    });
  }

  Future<void> markedAdd(Todo edited) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      http.put(Uri.parse("https://api.nstack.in/v1/todos/${edited.id}"),
          headers: header,
          body: jsonEncode({
            "title": edited.todo,
            "description": edited.description,
            "is_completed": true
          }));
      return _fetchTodo();
    });
  }

  Future<void> markedDelete(Todo edited) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      http.put(Uri.parse("https://api.nstack.in/v1/todos/${edited.id}"),
          headers: header,
          body: jsonEncode({
            "title": edited.todo,
            "description": edited.description,
            "is_completed": false
          }));
      return _fetchTodo();
    });
  }

  Future<void> changeById(Todo t, bool value) async {
    state = await AsyncValue.guard(() {
      http.post(Uri.parse("https://api.nstack.in/v1/todos/${t.id}"),
          body: jsonEncode({
            "title": t.todo,
            "description": t.description,
            "is_completed": value
          }));
      return _fetchTodo();
    });
  }
}

final futureTodoListProvider =
    AsyncNotifierProvider<FutureTodoListNotifier, List<Todo>>(
        () => FutureTodoListNotifier());
