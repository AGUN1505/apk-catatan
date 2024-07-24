import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:catatanku/model/model_database.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  final String notesTableName = 'tbl_catatan';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnContent = 'content';
  final String columnDate = 'date';

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database?> get checkDB async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  Future<Database?> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'catatan.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    var sql = '''
    CREATE TABLE $notesTableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTitle TEXT,
      $columnContent TEXT,
      $columnDate TEXT
    )
    ''';
    await db.execute(sql);
  }

  Future<int> saveNote(ModelCatatan note) async {
    var dbClient = await checkDB;
    return await dbClient!.insert(notesTableName, note.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var dbClient = await checkDB;
    var result = await dbClient!.query(notesTableName);
    return result.toList();
  }

  Future<int> updateNote(ModelCatatan note) async {
    var dbClient = await checkDB;
    return await dbClient!.update(notesTableName, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await checkDB;
    return await dbClient!
        .delete(notesTableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
