import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  TodoProvider({
    required this.database,
    this.todoList = const [],
  }) {
    initialize();
  }

  final Database database;
  late List<Todo> todoList;

  // データベースからTodoを取得し初期化
  Future<void> initialize() async {
    todoList = await getTodoList(database);
  }

  Future<List<Todo>> getTodoList(
    Database database,
  ) async {
    final List<Map<String, dynamic>> maps = await database.query('todo');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imagePath: maps[i]['imagePath'],
        createdAt: maps[i]['createdAt'],
      );
    });
  }

  Future<void> addTodo(Todo todo) async {
    // TodoNotifierへTodoを追加
    todoList.add(todo);

    // データベースへTodoを追加
    await database.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> updateTodo(
    Todo newTodo,
  ) async {
    final index = todoList.indexWhere((todo) => todo.id == newTodo.id);
    todoList[index] = newTodo;

    // データベースのTodoを更新
    await database.update(
      'todo',
      newTodo.toMap(),
      where: 'id = ?',
      whereArgs: [newTodo.id],
    );
    notifyListeners();
  }

  Future<void> deleteTodo(int targetTodoId) async {
    final existingTodoIndex =
        todoList.indexWhere((todo) => todo.id == targetTodoId);
    todoList.removeAt(existingTodoIndex);

    // データベースのTodoを削除
    await database.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [targetTodoId],
    );
    notifyListeners();
  }
}
