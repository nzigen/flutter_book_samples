import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../../../models/models.dart';
import '../../../../redux/redux.dart';
import '../../../../utilities/utilities.dart';

class TodoAddDialogModel extends ChangeNotifier with AutoCancelSubscriberMixin {
  TodoAddDialogModel({required Store<AppState> store})
      : _store = store,
        _textEditingController = TextEditingController() {
    _initialize();
  }

  final Store<AppState> _store;

  TextEditingController get textEditingController => _textEditingController;
  final TextEditingController _textEditingController;

  String get text => _textEditingController.text;

  List<Todo> get todos => _todos ?? [];
  List<Todo>? _todos;

  bool add(String text) {
    _store.dispatch(TodoAddAction(text));
    return true;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _initialize() {}
}
