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

  factory Todo.empty() =>
      Todo(todo: "", description: "", id: "", isCompleted: false);

  factory Todo.fromJson(Map<String, dynamic> m) {
    return Todo(
        todo: m['title'],
        description: m['description'],
        id: m['_id'],
        isCompleted: m['is_completed']);
  }
}
