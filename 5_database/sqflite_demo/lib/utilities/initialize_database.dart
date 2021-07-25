import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
    version: 2,
  );
  return database;
}

void _onCreate(
  Database database,
  int version,
) async {
  await _migrate(database, 0, version);
}

// アプリ公開後にDBのマイグレーションを実施するときに使用します
// scriptsにフィールドの追加、削除などを記載します
// 今回は例としてvideoPathを追加しています
void _onUpgrade(
  Database database,
  int oldVersion,
  int newVersion,
) async {
  await _migrate(database, oldVersion, newVersion);
}

Future<void> _migrate(Database database, int oldVersion, int newVersion) async {
  for (var i = oldVersion + 1; i <= newVersion; i++) {
    final queries = migrationScripts[i.toString()]!;
    for (final query in queries) {
      await database.execute(query);
    }
  }
}

const migrationScripts = {
  '1': [
    'CREATE TABLE todo(id INTEGER PRIMARY KEY, name TEXT, imagePath TEXT, createdAt TEXT)'
  ],
  '2': ['ALTER TABLE todo ADD COLUMN videoPath TEXT;'],
};
