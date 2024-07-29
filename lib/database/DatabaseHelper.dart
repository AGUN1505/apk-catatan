// Import paket-paket yang diperlukan
import 'package:CatatanKu/model/model_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Kelas untuk mengelola operasi database
class DatabaseHelper {
  // Singleton instance dari DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  // Instance database
  static Database? _database;

  // Inisialisasi beberapa variabel yang dibutuhkan
  final String tableName = 'tbl_keuangan';
  final String columnId = 'id';
  final String columnTipe = 'tipe';
  final String columnKet = 'keterangan';
  final String columnJmlUang = 'jml_uang';
  final String columnTgl = 'tanggal';

  // Konstruktor private untuk singleton
  DatabaseHelper._internal();

  // Factory constructor untuk mendapatkan instance DatabaseHelper
  factory DatabaseHelper() => _instance;

  // Getter untuk mendapatkan instance database
  Future<Database?> get checkDB async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  // Metode untuk menginisialisasi database
  Future<Database?> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'keuangan.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  // Metode untuk membuat tabel saat database pertama kali dibuat
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnTipe TEXT,"
        "$columnKet TEXT,"
        "$columnJmlUang TEXT,"
        "$columnTgl TEXT)";
    await db.execute(sql);
  }

  // Metode untuk menyimpan data ke database
  Future<int?> saveData(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.insert(tableName, modelDatabase.toMap());
  }

  // Metode untuk mengambil data pemasukan
  Future<List?> getDataPemasukan() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery(
        'SELECT * FROM $tableName WHERE $columnTipe = ?', ['pemasukan']);
    return result.toList();
  }

  // Metode untuk mengambil data pengeluaran
  Future<List?> getDataPengeluaran() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery(
        'SELECT * FROM $tableName WHERE $columnTipe = ?', ['pengeluaran']);
    return result.toList();
  }

  // Metode untuk menghitung jumlah pemasukan
  Future<int> getJmlPemasukan() async {
    try {
      var dbClient = await checkDB;
      var queryResult = await dbClient!.rawQuery(
          'SELECT SUM(CAST(jml_uang AS INTEGER)) AS TOTAL from $tableName WHERE $columnTipe = ?',
          ['pemasukan']);
      var total = queryResult.first['TOTAL'];
      if (total == null) {
        return 0;
      }
      // Konversi ke double terlebih dahulu untuk menangani nilai desimal
      return (double.tryParse(total.toString()) ?? 0).round();
    } catch (e) {
      print("Error dalam getJmlPemasukan: $e");
      return 0;
    }
  }

  // Metode untuk menghitung jumlah pengeluaran
  Future<int> getJmlPengeluaran() async {
    try {
      var dbClient = await checkDB;
      var queryResult = await dbClient!.rawQuery(
          'SELECT SUM(CAST(jml_uang AS INTEGER)) AS TOTAL from $tableName WHERE $columnTipe = ?',
          ['pengeluaran']);
      var total = queryResult.first['TOTAL'];
      if (total == null) {
        return 0;
      }
      // Konversi ke double terlebih dahulu untuk menangani nilai desimal
      return (double.tryParse(total.toString()) ?? 0).round();
    } catch (e) {
      print("Error dalam getJmlPengeluaran: $e");
      return 0;
    }
  }

  // Metode untuk memperbarui data pemasukan
  Future<int?> updateDataPemasukan(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(tableName, modelDatabase.toMap(),
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [modelDatabase.id, 'pemasukan']);
  }

  // Metode untuk memperbarui data pengeluaran
  Future<int?> updateDataPengeluaran(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(tableName, modelDatabase.toMap(),
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [modelDatabase.id, 'pengeluaran']);
  }

  // Metode untuk memeriksa jumlah data pemasukan
  Future<int?> cekDataPemasukan() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $columnTipe = ?',
        ['pemasukan']));
  }

  // Metode untuk memeriksa jumlah data pengeluaran
  Future<int?> cekDataPengeluaran() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $columnTipe = ?',
        ['pengeluaran']));
  }

  // Metode untuk menghapus data pemasukan berdasarkan ID
  Future<int?> deletePemasukan(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.delete(tableName,
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [id, 'pemasukan']);
  }

  // Metode untuk menghapus data pengeluaran berdasarkan ID
  Future<int?> deleteDataPengeluaran(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.delete(tableName,
        where: '$columnId = ? and $columnTipe = ?',
        whereArgs: [id, 'pengeluaran']);
  }
}
