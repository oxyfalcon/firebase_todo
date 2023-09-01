import 'package:app/Provider/future_provider.dart';
import 'package:app/button/main_buttons/add_button.dart';
import 'package:app/button/todo_list_page_buttons/delete_button.dart';
import 'package:app/button/todo_list_page_buttons/edit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tiles extends StatefulWidget {
  const Tiles({super.key});

  @override
  State<Tiles> createState() => _TilesState();
}

class _TilesState extends State<Tiles> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final newList = ref.watch(futureTodoListProvider);
      final futureState = ref.watch(futureTodoListProvider.notifier);
      return newList.when(
          data: (list) => Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: futureState.fetch,
                      child: ListView(children: [
                        for (var itr in list)
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: CheckboxListTile.adaptive(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    selected: itr.isCompleted,
                                    title: Text(itr.todo),
                                    subtitle: Text(itr.description),
                                    value: itr.isCompleted,
                                    secondary: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          EditButton(itr: itr),
                                          DeleteButton(
                                              todoState: ref.watch(
                                                  futureTodoListProvider
                                                      .notifier),
                                              itr: itr),
                                        ]),
                                    selectedTileColor: Theme.of(context)
                                        .copyWith(
                                            colorScheme: ColorScheme.fromSeed(
                                                seedColor: Colors.green))
                                        .colorScheme
                                        .secondaryContainer,
                                    onChanged: (change) {
                                      itr.isCompleted = change!;
                                      futureState.markedChange(
                                          itr: itr, change: change);
                                    }),
                              ))
                      ]),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: AddButton(),
                  )
                ],
              ),
          error: (error, stacktrace) => Text(error.toString()),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()));
    });
  }
}
