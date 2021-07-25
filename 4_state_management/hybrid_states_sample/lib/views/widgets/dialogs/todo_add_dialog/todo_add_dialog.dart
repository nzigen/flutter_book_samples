import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

import 'todo_add_dialog_model.dart';

class TodoAddDialog extends StatelessWidget {
  const TodoAddDialog._({Key? key}) : super(key: key);

  static Widget withDependencies({required BuildContext context}) {
    return ChangeNotifierProvider(
      create: (_context) => TodoAddDialogModel(
        store: StoreProvider.of(context),
      ),
      child: const TodoAddDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TodoAddDialogModel>(context);
    return AlertDialog(
      title: const Text('TODO'),
      content: TextField(
        autofocus: true,
        controller: model.textEditingController,
        decoration: const InputDecoration(hintText: '入力しましょう。'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () {
            if (model.add(model.text)) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('入力する'),
        )
      ],
    );
  }
}

Future<T?> showTodoAddDialog<T>({
  required BuildContext context,
}) =>
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TodoAddDialog.withDependencies(context: context),
    );
