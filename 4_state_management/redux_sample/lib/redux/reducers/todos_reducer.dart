import 'package:redux/redux.dart';

import '../redux.dart';

final Reducer<AppState> todosReducer = combineReducers(
  [
    TypedReducer<AppState, TodosSetAction>((state, action) => state.copyWith(
        todosState: state.todosState
            .copyWith(nextId: action.nextId, todos: action.todos))),
  ],
);
