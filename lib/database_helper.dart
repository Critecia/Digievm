import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'votes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE votes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            party_name TEXT UNIQUE,
            count INTEGER
          )
        ''');
      },
    );
  }

  Future<void> saveVotes(Map<String, String> votes) async {
    final db = await database;
    await db.delete('votes'); // Clear old data before saving new ones

    for (var entry in votes.entries) {
      await db.insert(
        'votes',
        {'party_name': entry.key, 'count': int.tryParse(entry.value) ?? 0},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getVotes() async {
    final db = await database;
    return await db.query('votes');
  }

  Future<void> resetVotes() async {
    final db = await database;
    await db.update('votes', {'count': 0});
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
