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

class PageDecider extends Notifier<Widget> {
  @override
  Widget build() {
    final watchingList = ref.watch(futureTodoListProvider);
    return watchingList.when(
      data: (watchingList) {
        if (watchingList.isEmpty) {
          return const NoToDoList();
        } else {
          return const Tiles();
        }
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

final pageDeciderProvider =
    NotifierProvider<PageDecider, Widget>(() => PageDecider());

class MarkedPageDecider extends Notifier<Widget> {
  @override
  Widget build() {
    final watchingList = ref.watch(futureTodoListProvider);
    return watchingList.when(
      data: (list) {
        bool flag = list.any((element) => (element.isCompleted == true));
        Widget temp;
        if (flag) {
          List<Todo> completedList = List.from(list.where(
              (element) => (element.isCompleted == true) ? true : false));
          temp = MarkedTiles(completedList: completedList);
        } else {
          temp = const MarkedNoTodoList();
        }
        return temp;
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

final markedPageDeciderProvider =
    NotifierProvider<MarkedPageDecider, Widget>(() => MarkedPageDecider());
