import 'package:todo_app/data/todo_reference.dart';

class Todo {
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );

  factory Todo.fromJson(Map<String, dynamic> json) {
    final completed = json[TodoReference.completed];
    return Todo(
      id: json[TodoReference.id],
      title: json[TodoReference.title],
      completed: (completed is bool) ? completed : completed == 1,
    );
  }

  Map<String, dynamic> toMap() =>
      {
        TodoReference.id: id,
        TodoReference.title: title,
        TodoReference.completed: (completed) ? 1 : 0,
      };

  @override
  String toString() {
    return 'Todo(id: $id, title: $title ,completed: $completed)';
  }
}
