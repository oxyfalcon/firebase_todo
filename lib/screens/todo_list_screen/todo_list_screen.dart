import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/notify_provider.dart';
import 'package:app/button/main_buttons/add_button.dart';
import 'package:app/button/todo_list_page_buttons/delete_button.dart';
import 'package:app/button/todo_list_page_buttons/edit_button.dart';
import 'package:flutter/material.dart';

class TileDisplay extends StatelessWidget {
  const TileDisplay({
    super.key,
    required this.futureState,
    required this.list
  });

  final FutureTodoListNotifier futureState;
  final List<Todo> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: futureState.fetch,
            child: ListView.builder(
                itemCount: list.length, itemBuilder: (context, itr) =>
                Padding(
                    padding: const EdgeInsets.all(8.0),
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
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                EditButton(itr: list[itr]),
                                DeleteButton(
                                    todoState: futureState,
                                    itr: list[itr]),
                              ]),
                          selectedTileColor: Theme
                              .of(context)
                              .copyWith(
                              colorScheme: ColorScheme.fromSeed(
                                  seedColor: Colors.green))
                              .colorScheme
                              .secondaryContainer,
                          onChanged: (change) {
                            list[itr].isCompleted = change!;
                            futureState.markedChange(
                                itr: list[itr], change: change);
                          }),
                    ))
                ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: AddButton(),
        )
      ],
    );
  }
}
