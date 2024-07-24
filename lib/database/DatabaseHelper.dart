import 'package:catatanku/model/model_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model Catatan
// class ModelCatatan {
//   int? id;
//   String? title;
//   String? content;
//   String? date;

//   ModelCatatan({this.id, this.title, this.content, this.date});

//   Map<String, dynamic> toMap() {
//     var map = Map<String, dynamic>();
//     if (id != null) {
//       map['id'] = id;
//     }
//     map['title'] = title;
//     map['content'] = content;
//     map['date'] = date;

//     return map;
//   }

//   ModelCatatan.fromMap(Map<String, dynamic> map) {
//     this.id = map['id'];
//     this.title = map['title'];
//     this.content = map['content'];
//     this.date = map['date'];
//   }
// }

// DatabaseHelper
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Inisialisasi beberapa variabel yang dibutuhkan
  final String tableName = 'tbl_keuangan';
  final String columnId = 'id';
  final String columnTipe = 'tipe';
  final String columnKet = 'keterangan';
  final String columnJmlUang = 'jml_uang';
  final String columnTgl = 'tanggal';

  // Variabel untuk tabel catatan
  // final String notesTableName = 'tbl_catatan';
  // final String notesColumnId = 'id';
  // final String notesColumnTitle = 'title';
  // final String notesColumnContent = 'content';
  // final String notesColumnDate = 'date';

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  // Cek apakah ada database
  Future<Database?> get checkDB async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  Future<Database?> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'keuangan.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Membuat tabel dan field-fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = '''
    CREATE TABLE $tableName(
      $columnId INTEGER PRIMARY KEY, 
      $columnTipe TEXT,
      $columnKet TEXT,
      $columnJmlUang TEXT,
      $columnTgl TEXT
    );

    ''';
    await db.execute(sql);
  }

  //   CREATE TABLE $notesTableName(
  //   $notesColumnId INTEGER PRIMARY KEY,
  //   $notesColumnTitle TEXT,
  //   $notesColumnContent TEXT,
  //   $notesColumnDate TEXT
  // );

  // Metode untuk tabel keuangan
  Future<int?> saveData(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.insert(tableName, modelDatabase.toMap());
  }

  Future<List?> getDataPemasukan() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery(
        'SELECT * FROM $tableName WHERE $columnTipe = ?', ['pemasukan']);
    return result.toList();
  }

  Future<List?> getDataPengeluaran() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery(
        'SELECT * FROM $tableName WHERE $columnTipe = ?', ['pengeluaran']);
    return result.toList();
  }

  Future<int> getJmlPemasukan() async {
    var dbClient = await checkDB;
    var queryResult = await dbClient!.rawQuery(
        'SELECT SUM(jml_uang) AS TOTAL from $tableName WHERE $columnTipe = ?',
        ['pemasukan']);
    int total = int.parse(queryResult[0]['TOTAL'].toString());
    return total;
  }

  Future<int> getJmlPengeluaran() async {
    var dbClient = await checkDB;
    var queryResult = await dbClient!.rawQuery(
        'SELECT SUM(jml_uang) AS TOTAL from $tableName WHERE $columnTipe = ?',
        ['pengeluaran']);
    int total = int.parse(queryResult[0]['TOTAL'].toString());
    return total;
  }

  Future<int?> updateDataPemasukan(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(tableName, modelDatabase.toMap(),
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [modelDatabase.id, 'pemasukan']);
  }

  Future<int?> updateDataPengeluaran(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(tableName, modelDatabase.toMap(),
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [modelDatabase.id, 'pengeluaran']);
  }

  Future<int?> cekDataPemasukan() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $columnTipe = ?',
        ['pemasukan']));
  }

  Future<int?> cekDataPengeluaran() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $columnTipe = ?',
        ['pengeluaran']));
  }

  Future<int?> deletePemasukan(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.delete(tableName,
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [id, 'pemasukan']);
  }

  Future<int?> deleteDataPengeluaran(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.delete(tableName,
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [id, 'pengeluaran']);
  }

  // Metode untuk tabel catatan
  // Future<int?> saveNote(ModelCatatan modelCatatan) async {
  //   var dbClient = await checkDB;
  //   return await dbClient!.insert(notesTableName, modelCatatan.toMap());
  // }

  // Future<List> getAllNotes() async {
  //   var dbClient = await checkDB;
  //   var result = await dbClient!.query(notesTableName);
  //   return result.toList();
  // }

  // Future<List<Map<String, dynamic>>> getAllNotes() async {
  //   var dbClient = await checkDB;
  //   return await dbClient!.query('tbl_catatan');
  // }

  // Future<int?> updateNote(ModelCatatan modelCatatan) async {
  //   var dbClient = await checkDB;
  //   return await dbClient!.update(notesTableName, modelCatatan.toMap(),
  //       where: '$notesColumnId = ?', whereArgs: [modelCatatan.id]);
  // }

  // Future<int?> deleteNote(int id) async {
  //   var dbClient = await checkDB;
  //   return await dbClient!
  //       .delete(notesTableName, where: '$notesColumnId = ?', whereArgs: [id]);
  // }
}
