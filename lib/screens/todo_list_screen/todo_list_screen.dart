import 'package:app/Provider/future_provider.dart';
import 'package:app/Provider/todo_schema.dart';
import 'package:app/button/todo_list_page_buttons/delete_button.dart';
import 'package:app/button/todo_list_page_buttons/edit_button.dart';
import 'package:app/screens/todo_list_screen/no_to_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileDisplay extends ConsumerStatefulWidget {
  const TileDisplay({super.key});

  @override
  ConsumerState<TileDisplay> createState() => _TileDisplayState();
}

class _TileDisplayState extends ConsumerState<TileDisplay>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () => ref.read(futureTodoListProvider.notifier).fetch(),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Stack(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final futureValue = ref.watch(futureTodoListProvider);
                      return futureValue.when(
                          data: (data) {
                            final list = ref.watch(itemsProvider(data));
                            if (list.isEmpty) {
                              return const CustomScrollView(
                                slivers: [
                                  SliverFillRemaining(child: NoTodoList())
                                ],
                              );
                            } else {
                              return SliverTodoList(list: list);
                            }
                          },
                          error: (error, stacktrace) => Column(
                                children: [
                                  Text(error.toString()),
                                  Text(stacktrace.toString())
                                ],
                              ),
                          loading: () => const Center(
                              child: CircularProgressIndicator.adaptive()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CheckBoxWidget extends ConsumerStatefulWidget {
  const CheckBoxWidget({super.key, required this.todo});

  final Todo todo;

  @override
  ConsumerState<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends ConsumerState<CheckBoxWidget> {
  bool? changeValue;

  @override
  Widget build(BuildContext context) {
    final futureState = ref.read(futureTodoListProvider.notifier);
    return CheckboxListTile.adaptive(
        controlAffinity: ListTileControlAffinity.leading,
        selected: widget.todo.isCompleted,
        title: Text(widget.todo.todo),
        subtitle: Text(widget.todo.description),
        value: widget.todo.isCompleted,
        secondary: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              EditButton(itr: widget.todo),
              DeleteButton(todoState: futureState, itr: widget.todo),
            ]),
        selectedTileColor: Theme.of(context).colorScheme.tertiaryContainer,
        onChanged: (change) {
          setState(() {
            widget.todo.isCompleted = change!;
            changeValue = change;
          });
          futureState.markedChange(itr: widget.todo, change: changeValue!);
        });
  }
}

class SliverTodoList extends ConsumerWidget {
  const SliverTodoList({super.key, required this.list});

  final List<Todo> list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverList.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => Dismissible(
                  onDismissed: (direction) => ref
                      .watch(futureTodoListProvider.notifier)
                      .deleteTodo(list[index]),
                  key: ValueKey(list[index]),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      child: CheckBoxWidget(todo: list[index]),
                    ),
                  ),
                )),
        const SliverPadding(
            padding: EdgeInsets.only(bottom: kMinInteractiveDimension))
      ],
    );
  }
}
