import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../redux/redux.dart';

class TodoAddDialog extends StatelessWidget {
  const TodoAddDialog({required this.textEditingController, Key? key})
      : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, viewModel) {
        return AlertDialog(
          title: const Text('TODO'),
          content: TextField(
            autofocus: true,
            controller: textEditingController,
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
                if (viewModel.add(textEditingController.value.text)) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('入力する'),
            )
          ],
        );
      });
}

Future<T?> showTodoAddDialog<T>({
  required BuildContext context,
}) =>
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TodoAddDialog(
        textEditingController: TextEditingController(),
      ),
    );

class _ViewModel {
  _ViewModel.fromStore(Store<AppState> store) : _store = store;

  final Store<AppState> _store;

  @override
  bool operator ==(other) => true;

  bool add(String name) {
    if (name.isEmpty) {
      return false;
    }
    _store.dispatch(TodoAddAction(name));
    return true;
  }
}
