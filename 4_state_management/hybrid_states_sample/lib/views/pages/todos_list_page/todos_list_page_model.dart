import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../utilities/utilities.dart';

extension _TodosListPageModelState on AppState {
  bool changedInTodos({
    required List<Todo>? todos,
  }) =>
      todosState.todos != todos;
}

class TodosListPageModel extends ChangeNotifier with AutoCancelSubscriberMixin {
  TodosListPageModel({required Store<AppState> store}) : _store = store {
    _initialize();
  }

  final Store<AppState> _store;

  List<Todo> get todos => _todos ?? [];
  List<Todo>? _todos;

  void deleteAt(int index) {
    _store.dispatch(TodoDeleteAction(todos[index].id));
  }

  void toggleComplete(int index) {
    _store.dispatch(TodoToggleCompletionAction(todos[index].id));
  }

  void _initialize() {
    _todos = _store.state.todosState.todos;
    subscriber.addSubscription(_store.onChange.listen((state) {
      if (state.changedInTodos(todos: todos)) {
        _todos = state.todosState.todos;
        notifyListeners();
      }
    }));
  }
}
