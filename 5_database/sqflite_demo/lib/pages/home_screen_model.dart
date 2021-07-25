import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../utilities/base64_helper.dart';

class HomeScreenModel extends ChangeNotifier {
  HomeScreenModel({
    required this.todoProvider,
  }) {
    textController.text = '';
  }
  final TodoProvider todoProvider;
  final textController = TextEditingController();

  List<Todo> get todoList => todoProvider.todoList;

  late String _taskName;
  late String _base64ImageString = '';

  String get base64ImageString => _base64ImageString;

  void addTodo() {
    /// 保存するTodoインスタンスを作成
    final todo = Todo(
      id: todoProvider.todoList.length,
      name: _taskName,
      // SQLiteではDatetime型は存在しないため、Iso8601String型として保存
      createdAt: DateTime.now().toIso8601String(),
      imagePath: _base64ImageString,
    );

    // Todoを保持するProviderを更新
    todoProvider.addTodo(todo);

    // 選択済み画像を未設定へ変更
    _base64ImageString = '';

    // Viewを再描画
    notifyListeners();
  }

  void deleteTodo(int id) {
    todoProvider.deleteTodo(id);
    notifyListeners();
  }

  void editTodo(Todo editingTodo) {
    /// 保存するTodoインスタンスを作成
    /// copyWithで変更値のみ更新
    final updatedTodo = editingTodo.copyWith(name: _taskName);

    // Todoを保持するProviderを更新
    todoProvider.updateTodo(updatedTodo);
  }

  /// 画像ファイル、ストレージアップロード関数
  Future selectImage() async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 800,
    );
    if (pickedFile == null) return;
    final imageFile = File(pickedFile.path);

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final copiedImageFile = await imageFile.copy('$path/$time.png');
    notifyListeners();

    // DBへ保存する為、base64文字列へ変換
    _base64ImageString =
        Base64Helper.base64String(copiedImageFile.readAsBytesSync());

    // 端末の一時ファイルを削除
    _deleteFile(imageFile);
  }

  // Todo名更新関数、一文字入力されるごとに呼び出されます
  void onNameChange(String text) {
    _taskName = text;
    notifyListeners();
  }

  /// 該当パスのファイルが存在しているときに、返却します
  Future<File?> _getLocalFile(File file) async {
    if (await File(file.path).exists()) {
      debugPrint('${file.path} deleted');
      return File(file.path);
    }
    return null;
  }

  /// 返却されたファイルパスが存在するときに、削除します
  void _deleteFile(
    File targetFile,
  ) async {
    try {
      final file = await _getLocalFile(targetFile);
      await file!.delete();
    } catch (e) {
      debugPrint('Delete file error: $e');
    }
  }
}
