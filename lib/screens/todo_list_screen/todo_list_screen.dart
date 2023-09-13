import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/todo_schema.dart';
import 'package:app/button/main_buttons/add_button.dart';
import 'package:app/button/todo_list_page_buttons/delete_button.dart';
import 'package:app/button/todo_list_page_buttons/edit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileDisplay extends StatelessWidget {
  const TileDisplay({super.key, required this.list});

  final List<Todo> list;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final FutureTodoListNotifier futureState =
          ref.watch(futureTodoListProvider.notifier);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: futureState.fetch,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, itr) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Card(
                            child: CheckboxListTile.adaptive(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                selected: list[itr].isCompleted,
                                title: Text(list[itr].todo),
                                subtitle: Text(list[itr].description),
                                value: list[itr].isCompleted,
                                secondary: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      EditButton(itr: list[itr]),
                                      DeleteButton(
                                          todoState: futureState,
                                          itr: list[itr]),
                                    ]),
                                selectedTileColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                onChanged: (change) {
                                  list[itr].isCompleted = change!;
                                  futureState.markedChange(
                                      itr: list[itr], change: change);
                                }),
                          ),
                        )),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.all(20.0),
            child: const AddButton(),
          )
        ],
      );
    });
  }
}
