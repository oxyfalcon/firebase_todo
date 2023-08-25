import 'package:app/Provider/future_provider.dart';
import 'package:app/button/main_buttons/add_button.dart';
import 'package:app/button/todo_list_page_buttons/delete_button.dart';
import 'package:app/button/todo_list_page_buttons/edit_button.dart';
import 'package:app/button/main_buttons/done_list_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowingTodo extends StatelessWidget {
  const ShowingTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Tiles(),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 30.0, left: 25, top: 20, right: 25),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomRight,
                  child: const DoneListButton(),
                ),
                Container(
                    alignment: Alignment.bottomRight, child: const AddButton()),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Tiles extends ConsumerStatefulWidget {
  const Tiles({super.key});

  @override
  ConsumerState<Tiles> createState() => _TilesState();
}

class _TilesState extends ConsumerState<Tiles> {
  @override
  Widget build(BuildContext context) {
    debugPrint("tile Widget build");
    final newList = ref.watch(futureTodoListProvider);
    final futureState = ref.watch(futureTodoListProvider.notifier);
    return newList.when(
        data: (list) => Expanded(
              child: RefreshIndicator(
                onRefresh: futureState.fetch,
                child: ListView(children: [
                  for (var itr in list)
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: CheckboxListTile.adaptive(
                              controlAffinity: ListTileControlAffinity.leading,
                              selected: itr.completed,
                              title: Text(itr.todo),
                              subtitle: Text(itr.description),
                              value: itr.completed,
                              secondary: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    EditButton(itr: itr),
                                    DeleteButton(
                                        todoState: ref.watch(
                                            futureTodoListProvider.notifier),
                                        itr: itr),
                                  ]),
                              selectedTileColor: Theme.of(context)
                                  .copyWith(
                                      colorScheme: ColorScheme.fromSeed(
                                          seedColor: Colors.green))
                                  .colorScheme
                                  .secondaryContainer,
                              onChanged: (change) {
                                setState(() {
                                  itr.completed = change!;
                                });
                              }),
                        ))
                ]),
              ),
            ),
        error: (error, stacktrace) => Text(error.toString()),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }
}
