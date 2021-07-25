import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../views/views.dart';

class TodosListPage extends StatefulWidget {
  const TodosListPage({Key? key}) : super(key: key);

  @override
  _TodosListPageState createState() => _TodosListPageState();
}

class _TodosListPageState extends State<TodosListPage> {
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOアプリ'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return Dismissible(
            child: Card(
              child: ListTile(
                title: Text(todo.name),
                onTap: () {
                  setState(() {
                    _todos[index] =
                        Todo(isCompleted: !todo.isCompleted, name: todo.name);
                  });
                },
                trailing: todo.isCompleted
                    ? const Icon(
                        Icons.done,
                        color: Colors.green,
                      )
                    : null,
              ),
              color: todo.isCompleted ? Colors.greenAccent : null,
            ),
            key: ObjectKey(todo),
            onDismissed: (direction) {
              setState(() {
                _todos.removeAt(index);
              });
            },
          );
        },
        itemCount: _todos.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoAddDialog(
              context: context,
              onAdd: (name) {
                setState(() {
                  _todos.insert(0, Todo(name: name));
                });
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
