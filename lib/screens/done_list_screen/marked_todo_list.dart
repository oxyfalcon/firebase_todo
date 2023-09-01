import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/notify_provider.dart';
import 'package:app/button/done_list_page_buttons/done_delete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkedTiles extends StatelessWidget {
  const MarkedTiles({super.key, required this.completedList});
  final List<Todo> completedList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer(builder: (context, ref, child) {
        final todoState = ref.watch(futureTodoListProvider.notifier);
        return RefreshIndicator(
          onRefresh: () => todoState.fetch(),
          child: ListView.builder(
            itemCount: completedList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                    horizontalTitleGap: 10,
                    subtitle: Text(completedList[index].description),
                    trailing: DoneDeleteButton(
                        todoState: todoState, itr: completedList[index]),
                    title: Text(completedList[index].todo)),
              ),
            ),
          ),
        );
      }),
    );
  }
}
