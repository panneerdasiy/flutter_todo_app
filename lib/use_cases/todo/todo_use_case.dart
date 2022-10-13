import 'dart:developer';

import 'package:todo_app/data/local/abstract_todo_dao.dart';
import 'package:todo_app/data/remote/abstract_todo_service.dart';
import 'package:todo_app/screens/dashboard/bloc/todo.dart';
import 'package:todo_app/use_cases/todo/abstract_todo_use_case.dart';

class TodoUseCase implements AbstractTodoUseCase {
  final AbstractTodoDao _todoDao;
  final AbstractTodoService _todoService;

  const TodoUseCase(this._todoDao, this._todoService);

  @override
  Future<List<Todo>> getTodos() async {
    List<Todo> todos = await getLocalTodos();
    log('from db todos = ${todos.length}');
    if (todos.isEmpty) {
      todos = await _todoService.getTodos();
      log('result of insert: ${await _todoDao.insertTodos(todos)}');
    }
    return todos;
  }

  @override
  Future<List<Todo>> getLocalTodos() async {
    return await _todoDao.getTodos();
  }

  @override
  Future<Todo?> getTodo(int id) async {
    Todo? todo = await _todoDao.getTodo(id);
    log('from db todo = $todo');
    return todo;
  }

  @override
  Future<int> updateTodo(Todo todo) async {
    return _todoDao.updateTodo(todo);
  }

  @override
  Future<int> deleteTodo(Todo todo) async {
    return _todoDao.deleteTodo(todo);
  }

  @override
  Future<int> saveTodo(Todo todo) async {
    return _todoDao.saveTodo(todo);
  }
}
