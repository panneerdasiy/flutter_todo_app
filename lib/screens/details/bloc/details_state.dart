import 'package:todo_app/screens/dashboard/bloc/todo.dart';
import 'package:todo_app/screens/todo_actions.dart';

class DetailsState {
  final bool isLoading;
  final Todo? todo;
  final TodoActions? actionDone;

  const DetailsState({
    this.isLoading = false,
    this.todo,
    this.actionDone,
  });

  DetailsState copyWith({
    bool? isLoading,
    Todo? todo,
    TodoActions? actionDone,
  }) =>
      DetailsState(
          isLoading: isLoading ?? this.isLoading,
          todo: todo ?? this.todo,
          actionDone: actionDone ?? this.actionDone);

  @override
  String toString() {
    return 'DetailsState(isLoading: $isLoading, todo: $todo, actionDone: $actionDone';
  }
}
