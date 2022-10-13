import 'package:todo_app/screens/dashboard/bloc/todo.dart';

class DashboardState {
  final bool isLoading;
  final String todosApiError;
  final List<Todo> todos;
  final Todo? todoToOpen;
  final bool logOut;

  const DashboardState({
    this.isLoading = false,
    required this.todosApiError,
    required this.todos,
    this.todoToOpen,
    this.logOut = false,
  });

  DashboardState copyWith({
    bool? isLoading,
    String? todosApiError,
    List<Todo>? todos,
    Todo? todoToOpen,
    bool? logOut = false,
  }) =>
      DashboardState(
        isLoading: isLoading ?? this.isLoading,
        todosApiError: todosApiError ?? this.todosApiError,
        todos: todos ?? this.todos,
        todoToOpen: todoToOpen ?? this.todoToOpen,
        logOut: logOut ?? this.logOut
      );
}
