import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/models.dart';
import '../../redux/redux.dart';
import '../views.dart';

class TodosListPage extends StatelessWidget {
  const TodosListPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redux TODO'),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, viewModel) {
          final todos = viewModel.todos;
          return ListView.builder(
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Dismissible(
                key: ObjectKey(todo),
                onDismissed: (direction) {
                  viewModel.deleteAt(index);
                },
                child: Card(
                  color: todo.isCompleted ? Colors.greenAccent : null,
                  child: ListTile(
                    title: Text(todo.name),
                    onTap: () {
                      viewModel.toggleComplete(index);
                    },
                    trailing: todo.isCompleted
                        ? const Icon(
                            Icons.done,
                            color: Colors.green,
                          )
                        : null,
                  ),
                ),
              );
            },
            itemCount: todos.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoAddDialog(context: context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _ViewModel {
  _ViewModel.fromStore(Store<AppState> store)
      : _store = store,
        todos = store.state.todosState.todos;

  final List<Todo> todos;

  final Store<AppState> _store;

  @override
  bool operator ==(other) {
    if (other is _ViewModel) {
      if (other.todos == todos) {
        return true;
      }
      if (other.todos.length != todos.length) {
        return false;
      }
      for (var index = 0; index < todos.length; index++) {
        if (other.todos[index] != todos[index]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  void deleteAt(int index) {
    _store.dispatch(TodoDeleteAction(todos[index].id));
  }

  void toggleComplete(int index) {
    _store.dispatch(TodoToggleCompletionAction(todos[index].id));
  }
}
