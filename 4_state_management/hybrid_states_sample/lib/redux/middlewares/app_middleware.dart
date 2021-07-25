import 'package:redux/redux.dart';

import '../redux.dart';
import 'todos_middleware.dart';

final List<Middleware<AppState>> appMiddleware = [
  todosMiddleware,
].expand((middleware) => middleware).toList(growable: false);
