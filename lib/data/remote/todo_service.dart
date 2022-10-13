import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/data/remote/abstract_todo_service.dart';
import 'package:todo_app/data/remote/api_exception.dart';
import 'package:todo_app/screens/dashboard/bloc/todo.dart';

class TodoService implements AbstractTodoService {
  @override
  Future<List<Todo>> getTodos() async {
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Todo> todos = body.map((e) => Todo.fromJson(e)).toList();

      return todos;
    }

    throw ApiException('Api Failed with status code: ${response.statusCode}');
  }
}
