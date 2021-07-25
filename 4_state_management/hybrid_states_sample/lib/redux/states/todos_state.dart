import '../../models/models.dart';

class TodosState {
  TodosState._({
    required this.nextId,
    required this.todos,
  });

  TodosState.initialize()
      : nextId = 1,
        todos = [];

  final int nextId;
  final List<Todo> todos;

  TodosState copyWith({
    int? nextId,
    List<Todo>? todos,
  }) =>
      TodosState._(
        nextId: nextId ?? this.nextId,
        todos: todos ?? this.todos,
      );

  @override
  String toString() => 'TodosState{'
      'nextId:$nextId,'
      'todos:$todos,'
      '}';
}
