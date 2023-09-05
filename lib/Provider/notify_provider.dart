import 'package:app/Provider/future_provider.dart';
import 'package:app/screens/todo_list_screen/no_to_list.dart';
import 'package:app/screens/done_list_screen/marked_no_to_do_list.dart';
import 'package:app/screens/done_list_screen/marked_todo_list.dart';
import 'package:app/screens/todo_list_screen/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  String todo;
  String description;
  String id;
  bool isCompleted;

  Todo(
      {required this.todo,
      required this.description,
      required this.id,
      required this.isCompleted});

  factory Todo.fromJson(Map<String, dynamic> m) {
    return Todo(
        todo: m['title'],
        description: m['description'],
        id: m['_id'],
        isCompleted: m['is_completed']);
  }
}

class PageDecider extends AutoDisposeNotifier<Widget> {
  @override
  Widget build() => buildHelper();

  Widget buildHelper() {
    final watchingList = ref.watch(futureTodoListProvider);
    final futureTodoListNotifier = ref.read(futureTodoListProvider.notifier);
    return watchingList.when(
      data: (watchingList) {
        if (watchingList.isEmpty) {
          return const NoToDoList();
        } else {
          return TileDisplay(
            futureState: futureTodoListNotifier,
            list: watchingList,
          );
        }
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const Center(
            child: CircularProgressIndicator(color: Colors.red));
      },
    );
  }
}

final pageDeciderProvider =
    AutoDisposeNotifierProvider<PageDecider, Widget>(() => PageDecider());

class MarkedPageDecider extends AutoDisposeNotifier<Widget> {
  Widget _buildHelper() {
    final watchingList = ref.watch(futureTodoListProvider);
    return watchingList.when(
      data: (list) {
        bool flag = list.any((element) => (element.isCompleted == true));
        if (flag) {
          List<Todo> completedList = List.from(list.where(
              (element) => (element.isCompleted == true) ? true : false));
          return MarkedTiles(completedList: completedList);
        } else {
          return const MarkedNoTodoList();
        }
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(
          child: CircularProgressIndicator(
        color: Colors.black,
      )),
    );
  }

  @override
  Widget build() {
    return _buildHelper();
  }
}

final markedPageDeciderProvider =
    AutoDisposeNotifierProvider<MarkedPageDecider, Widget>(
        () => MarkedPageDecider());
