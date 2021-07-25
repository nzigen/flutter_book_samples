import 'package:flutter/material.dart';

class TodoAddDialog extends StatelessWidget {
  const TodoAddDialog(
      {required this.onAdd, required this.textEditingController, Key? key})
      : super(key: key);

  final ValueChanged<String> onAdd;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('TODO'),
        content: TextField(
          autofocus: true,
          controller: textEditingController,
          decoration: const InputDecoration(hintText: '入力しましょう。'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('入力する'),
            onPressed: () {
              onAdd(textEditingController.value.text);
              Navigator.of(context).pop();
            },
          )
        ],
      );
}

Future<T?> showTodoAddDialog<T>({
  required BuildContext context,
  required ValueChanged<String> onAdd,
}) =>
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TodoAddDialog(
        textEditingController: TextEditingController(),
        onAdd: onAdd,
      ),
    );
