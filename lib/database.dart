import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(path, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE movies(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, category TEXT, description TEXT, rating INTEGER, release_year INTEGER, date TEXT)',
      );
    }, version: 1);
  }

  Future<void> insertMovie(Map<String, dynamic> movie) async {
    final db = await database;
    movie['date'] = DateTime.now().toIso8601String(); // Obtém a data e hora atual
    await db.insert('movies', movie);
  }

  Future<List<Map<String, dynamic>>> getMovies() async {
    final db = await database;
    return await db.query('movies');
  }

  Future<void> deleteMovie(int id) async {
    final db = await database;
    await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}
