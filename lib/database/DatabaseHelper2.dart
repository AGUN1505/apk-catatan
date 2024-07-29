// Import paket-paket yang diperlukan
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:CatatanKu/model/model_database.dart';

// Kelas untuk mengelola operasi database catatan
class DatabaseHelper2 {
  // Singleton instance dari DatabaseHelper2
  static final DatabaseHelper2 _instance = DatabaseHelper2._internal2();
  // Instance database
  static Database? _database2;

  // Nama tabel dan kolom-kolom dalam database
  final String notesTableName = 'tbl_catatan';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnContent = 'content';
  final String columnDate = 'date';

  // Konstruktor private untuk singleton
  DatabaseHelper2._internal2();

  // Factory constructor untuk mendapatkan instance DatabaseHelper2
  factory DatabaseHelper2() => _instance;

  // Getter untuk mendapatkan instance database
  Future<Database?> get checkDB async {
    if (_database2 != null) {
      return _database2;
    }
    _database2 = await _initDB2();
    return _database2;
  }

  // Metode untuk menginisialisasi database
  Future<Database?> _initDB2() async {
    String databasePath2 = await getDatabasesPath();
    String path2 = join(databasePath2, 'catatan.db');
    return await openDatabase(path2, version: 1, onCreate: _onCreate);
  }

  // Metode untuk membuat tabel saat database pertama kali dibuat
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

  // Metode untuk menyimpan catatan baru
  Future<int> saveNote(ModelCatatan note) async {
    var dbClient = await checkDB;
    return await dbClient!.insert(notesTableName, note.toMap());
  }

  // Metode untuk mengambil semua catatan
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var dbClient = await checkDB;
    var result = await dbClient!.query(notesTableName);
    return result.toList();
  }

  // Metode untuk memperbarui catatan yang sudah ada
  Future<int> updateNote(ModelCatatan note) async {
    var dbClient = await checkDB;
    return await dbClient!.update(notesTableName, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  // Metode untuk menghapus catatan berdasarkan ID
  Future<int> deleteNote(int id) async {
    var dbClient = await checkDB;
    return await dbClient!
        .delete(notesTableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
