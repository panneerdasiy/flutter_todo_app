
import 'package:todo_app/screens/dashboard/bloc/todo.dart';

abstract class AbstractTodoService {

  Future<List<Todo>> getTodos();
}