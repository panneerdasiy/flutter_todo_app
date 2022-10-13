
import 'package:todo_app/screens/dashboard/bloc/todo.dart';

abstract class AbstractTodoDao{
  Future<List<Todo>> getTodos();
  Future<Todo?> getTodo(int id);
  Future<int> updateTodo(Todo todo);
  Future<int> deleteTodo(Todo todo);
  Future<int> saveTodo(Todo todo);
  Future<List<Object?>> insertTodos(List<Todo> todos);
}