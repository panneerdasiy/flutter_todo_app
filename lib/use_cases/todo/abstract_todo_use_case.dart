import 'package:todo_app/screens/dashboard/bloc/todo.dart';

abstract class AbstractTodoUseCase {
  Future<List<Todo>> getTodos();

  Future<List<Todo>> getLocalTodos();

  Future<Todo?> getTodo(int id);

  Future<int> updateTodo(Todo todo);

  Future<int> deleteTodo(Todo todo);

  Future<int> saveTodo(Todo todo);
}
