import 'package:todo_app/screens/dashboard/bloc/todo.dart';

abstract class DashboardEvent {}

class GetTodosEvent extends DashboardEvent {}
class LogoutEvent extends DashboardEvent {}

class SaveResultEvent extends DashboardEvent {
  final Todo todo;

  SaveResultEvent(this.todo);
}

class DeleteResultEvent extends DashboardEvent {
  final Todo todo;

  DeleteResultEvent(this.todo);
}

class UpdateResultEvent extends DashboardEvent {
  final int todoId;

  UpdateResultEvent(this.todoId);
}

class UpdateTodoEvent extends DashboardEvent {
  final Todo todo;

  UpdateTodoEvent(this.todo);
}

class OpenTodoEvent extends DashboardEvent {
  final Todo todo;

  OpenTodoEvent(this.todo);
}
