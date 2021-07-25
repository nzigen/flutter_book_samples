import '../../models/models.dart';

class TodoAddAction {
  const TodoAddAction(this.name);

  final String name;
}

class TodoDeleteAction {
  const TodoDeleteAction(this.id);

  final int id;
}

class TodosLoadAction {
  const TodosLoadAction();
}

class TodosSaveAction {
  const TodosSaveAction();
}

class TodosSetAction {
  const TodosSetAction({this.nextId, required this.todos});

  final int? nextId;
  final List<Todo> todos;
}

class TodoToggleCompletionAction {
  const TodoToggleCompletionAction(this.id);

  final int id;
}
