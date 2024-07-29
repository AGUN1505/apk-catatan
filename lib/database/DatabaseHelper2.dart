import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:CatatanKu/model/model_database.dart';

class DatabaseHelper2 {
  static final DatabaseHelper2 _instance = DatabaseHelper2._internal2();
  static Database? _database2;

  final String notesTableName = 'tbl_catatan';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnContent = 'content';
  final String columnDate = 'date';

  DatabaseHelper2._internal2();

  factory DatabaseHelper2() => _instance;

  Future<Database?> get checkDB async {
    if (_database2 != null) {
      return _database2;
    }
    _database2 = await _initDB2();
    return _database2;
  }

  Future<Database?> _initDB2() async {
    String databasePath2 = await getDatabasesPath();
    String path2 = join(databasePath2, 'catatan.db');
    return await openDatabase(path2, version: 1, onCreate: _onCreate);
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
