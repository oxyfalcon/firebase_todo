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
  bool completed = false;

  Todo({required this.todo, required this.description, required this.id});

  factory Todo.fromJson(Map<String, dynamic> m) {
    return Todo(todo: m['title'], description: m['description'], id: m['_id']);
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
          return const ShowingTodo();
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
        bool flag = true;
        for (var itr in list) {
          if (itr.completed == true) {
            flag = false;
            break;
          }
        }
        Widget temp;
        (flag) ? temp = const MarkedNoTodoList() : temp = const MarkedTiles();
        return temp;
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}

final markedPageDeciderProvider =
    NotifierProvider<MarkedPageDecider, Widget>(() => MarkedPageDecider());
