import 'package:todo_app/screens/dashboard/bloc/todo.dart';
import 'package:todo_app/screens/todo_actions.dart';

class DetailsScreenResult {
  final TodoActions actions;
  final Todo todo;

  const DetailsScreenResult(this.actions, this.todo);
}
