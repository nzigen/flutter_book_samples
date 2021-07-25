import 'package:redux/redux.dart';

import '../redux.dart';
import 'todos_reducer.dart';

final Reducer<AppState> appReducer = combineReducers<AppState>(
  [
    todosReducer,
  ],
);
