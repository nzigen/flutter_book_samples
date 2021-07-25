import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'redux/redux.dart';
import 'views/pages/pages.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initialize(), middleware: appMiddleware);

  runApp(MyApp(store: store));

  store.dispatch(const TodosLoadAction());
}

class MyApp extends StatelessWidget {
  const MyApp({key, required this.store}) : super(key: key);

  final Store<AppState> store;
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const TodosListPage(),
      ),
    );
  }
}
