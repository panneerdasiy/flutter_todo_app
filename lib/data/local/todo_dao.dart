import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/local/abstract_todo_dao.dart';
import 'package:todo_app/data/todo_reference.dart';
import 'package:todo_app/screens/dashboard/bloc/todo.dart';

class TodoDao implements AbstractTodoDao {
  final _dbName = "todos.db";
  final _dbVersion = 1;

  static const table = 'todo';

  static const columnId = TodoReference.id;
  static const columnTitle = TodoReference.title;
  static const columnCompleted = TodoReference.completed;

  TodoDao._internal();

  static final TodoDao instance = TodoDao._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) {
    return db.execute('''CREATE TABLE $table(
                            $columnId INTEGER PRIMARY KEY,
                            $columnTitle TEXT, 
                            $columnCompleted INTEGER
                          )''');
  }

  @override
  Future<List<Todo>> getTodos() async {
    final db = await database;
    List<Map<String, dynamic>> todos = await db.query(table);
    return todos.map((e) => Todo.fromJson(e)).toList();
  }

  @override
  Future<Todo?> getTodo(int id) async {
    final db = await database;
    List<Map<String, dynamic>> todos =
        await db.query(table, where: '$columnId = ?', whereArgs: [id]);

    if (todos.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> map = todos.first;
      return Todo.fromJson(map);
    }
  }

  @override
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    int id = todo.id;
    return await db.update(table, todo.toMap(),
        where: '$columnId = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<int> deleteTodo(Todo todo) async {
    final db = await database;
    int id = todo.id;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<int> saveTodo(Todo todo) async {
    final db = await database;
    return await db.insert(table, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Object?>> insertTodos(List<Todo> todos) async {
    final db = await database;
    Batch batch = db.batch();
    for (final todo in todos) {
      batch.insert(table, todo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return batch.commit(noResult: true);
  }
}
