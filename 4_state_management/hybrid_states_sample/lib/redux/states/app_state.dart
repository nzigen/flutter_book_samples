import 'todos_state.dart';

class AppState {
  AppState._({
    required this.todosState,
  });

  AppState.initialize() : todosState = TodosState.initialize();

  final TodosState todosState;

  AppState copyWith({
    TodosState? todosState,
  }) =>
      AppState._(
        todosState: todosState ?? this.todosState,
      );

  @override
  String toString() => 'AppState{'
      'todosState:$todosState,'
      '}';
}
