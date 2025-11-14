import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? db;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDb('mydb.db');
    return db!;
  }

  Future<Database> initDb(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return openDatabase(path, version: 1, onCreate: createDb);
  }

  Future<void> createDb(Database db, int version) async {
    await db.execute('''CREATE TABLE users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    password TEXT
    )''');
  }

  Future<List<Map>> read() async {
    final db = await instance.database;
    return db.query('users');
  }

  Future<int> update(int id, String name, String password) async {
    final db = await instance.database;
    return db.update(
      'users',
      {"name": name, "password": password},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete('users', where: 'id=?', whereArgs: [id]);
  }

  Future<int> insert(String name, String password) async {
    final db = await instance.database;
    return (db.insert('users', {"name": name, 'password': password}));
  }

  Future<bool> canLogin(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'name=? AND password=?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }
}
