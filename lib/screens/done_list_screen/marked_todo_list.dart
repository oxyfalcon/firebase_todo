import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/todo_schema.dart';
import 'package:app/button/done_list_page_buttons/done_delete.dart';
import 'package:app/screens/done_list_screen/marked_no_to_do_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkedTiles extends ConsumerWidget {
  const MarkedTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Todo>> initValue = ref.watch(futureTodoListProvider);
    final FutureTodoListNotifier futureNotifier =
        ref.read(futureTodoListProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () => futureNotifier.fetch(),
            child: initValue.when(
              data: (data) {
                final list = ref.watch(itemsProvider(data));
                List<Todo> completedList = [];
                bool flag =
                    list.any((element) => (element.isCompleted == true));
                if (flag) {
                  completedList = List.from(list.where((element) =>
                      (element.isCompleted == true) ? true : false));
                  return MarkedList(completedList: completedList);
                } else {
                  return const CustomScrollView(slivers: [
                    SliverFillRemaining(child: MarkedNoTodoList())
                  ]);
                }
              },
              error: (error, stacktrace) => Column(
                children: [Text(error.toString()), Text(stacktrace.toString())],
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        ),
      ],
    );
  }
}

class MarkedList extends StatelessWidget {
  const MarkedList({
    super.key,
    required this.completedList,
  });

  final List<Todo> completedList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: completedList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
              horizontalTitleGap: 10,
              subtitle: Text(completedList[index].description),
              trailing: DoneDeleteButton(todo: completedList[index]),
              title: Text(completedList[index].todo)),
        ),
      ),
    );
  }
}
