import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/rounded_button.dart';
import 'home_screen_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen._({Key? key}) : super(key: key);

  static Widget withDependencies() {
    return ChangeNotifierProvider(
      create: (_context) => HomeScreenModel(),
      child: const HomeScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildTodoList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList(BuildContext context) {
    final notifier = Provider.of<HomeScreenModel>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('to-dos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // エラーの場合
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Container();
        } else {
          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot todo) {
                return Card(
                  child: ListTile(
                    dense: true,
                    leading: Checkbox(
                      value: todo['isCompleted'],
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      onChanged: (val) {
                        notifier.updateTodoIsCompleted(
                          documentId: todo.id,
                          isCompleted: !todo['isCompleted'],
                        );
                      },
                    ),
                    title: InkWell(
                      onTap: () {
                        _showEditTodoDialog(
                          context: context,
                          documentId: todo.id,
                          editingText: todo['name'] ?? '',
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          todo['name'] ?? '',
                          style: TextStyle(
                            fontSize: 15.0,
                            decoration: todo['isCompleted']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    // 画像部分の表示
                    subtitle: todo['imagePath'].isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: InkWell(
                                onTap: () {
                                  _showEditTodoDialog(
                                    context: context,
                                    documentId: todo.id,
                                    editingText: todo['name'] ?? '',
                                  );
                                },
                                child: Image.network(
                                  todo['imagePath'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                );
              },
            ).toList(),
          );
        }
      },
    );
  }

  /// TODOタスク追加時の表示ダイアログ
  void _showAddTodoDialog({
    required BuildContext context,
  }) {
    final model = Provider.of<HomeScreenModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              children: <Widget>[
                SimpleDialogOption(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            autofocus: true,
                            initialValue: '',
                            onChanged: model.onNameChange,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (model.image != null)
                        SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.file(model.image!),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RoundedButton(
                            title: '画像追加',
                            onPressed: () async {
                              await model.uploadFile();
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 10),
                          RoundedButton(
                            title: '投稿',
                            onPressed: () {
                              // Todo追加関数実行前に、ダイアログを閉じます
                              Navigator.of(context).pop();
                              model.createPost();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTodoDialog({
    required BuildContext context,
    required String documentId,
    required String editingText,
  }) {
    final model = Provider.of<HomeScreenModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              children: <Widget>[
                SimpleDialogOption(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            autofocus: true,
                            initialValue: editingText,
                            onChanged: model.onNameChange,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RoundedButton(
                            title: '削除',
                            onPressed: () {
                              // Todo削除関数実行前に、ダイアログを閉じます
                              Navigator.of(context).pop();
                              model.deleteTodo(documentId);
                            },
                          ),
                          const SizedBox(width: 10),
                          RoundedButton(
                            title: '変更',
                            onPressed: () {
                              // Todo編集関数実行前に、ダイアログを閉じます
                              Navigator.of(context).pop();
                              model.updateTodoName(
                                documentId: documentId,
                                editingText: editingText,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
