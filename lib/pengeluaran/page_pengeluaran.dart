// Import paket-paket yang diperlukan
import 'package:flutter/material.dart';
import 'package:CatatanKu/decoration/format_rupiah.dart';
import 'package:CatatanKu/database/DatabaseHelper.dart';
import 'package:CatatanKu/model/model_database.dart';
import 'package:CatatanKu/pengeluaran/page_input_pengeluaran.dart';

// Mendefinisikan widget StatefulWidget untuk halaman pengeluaran
class PagePengeluaran extends StatefulWidget {
  const PagePengeluaran({Key? key}) : super(key: key);

  @override
  State<PagePengeluaran> createState() => _PagePengeluaranState();
}

// Mendefinisikan state untuk PagePengeluaran
class _PagePengeluaranState extends State<PagePengeluaran> {
  // Inisialisasi variabel-variabel yang diperlukan
  List<ModelDatabase> listPemasukan =
      []; // List untuk menyimpan data pengeluaran
  DatabaseHelper databaseHelper =
      DatabaseHelper(); // Objek untuk mengakses database
  int strJmlUang = 0; // Variabel untuk menyimpan jumlah total pengeluaran
  int strCheckDatabase =
      0; // Variabel untuk mengecek apakah database kosong atau tidak

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi-fungsi untuk inisialisasi data
    getDatabase();
    getJmlUang();
    getAllData();
  }

  // Fungsi untuk mengecek apakah database memiliki data atau tidak
  Future<void> getDatabase() async {
    var checkDB = await databaseHelper.cekDataPengeluaran();
    setState(() {
      if (checkDB == 0) {
        strCheckDatabase = 0;
        strJmlUang = 0;
      } else {
        strCheckDatabase = checkDB!;
      }
    });
  }

  // Fungsi untuk mendapatkan jumlah total pengeluaran
  Future<void> getJmlUang() async {
    var checkJmlUang = await databaseHelper.getJmlPengeluaran();
    setState(() {
      if (checkJmlUang == 0) {
        strJmlUang = 0;
      } else {
        strJmlUang = checkJmlUang;
      }
    });
  }

  // Fungsi untuk mendapatkan semua data pengeluaran dari database
  Future<void> getAllData() async {
    var listData = await databaseHelper.getDataPengeluaran();
    setState(() {
      listPemasukan.clear();
      listData!.forEach((kontak) {
        listPemasukan.add(ModelDatabase.fromMap(kontak));
      });
    });
  }

  // Fungsi untuk menghapus data pengeluaran berdasarkan ID
  Future<void> deleteData(ModelDatabase modelDatabase, int position) async {
    await databaseHelper.deleteDataPengeluaran(modelDatabase.id!);
    setState(() {
      getJmlUang();
      getDatabase();
      listPemasukan.removeAt(position);
    });
  }

  // Fungsi untuk membuka form penambahan data baru
  Future<void> openFormCreate() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PageInputPengeluaran()));
    if (result == 'save') {
      await getAllData();
      await getJmlUang();
      await getDatabase();
    }
  }

  // Fungsi untuk membuka form edit data
  Future<void> openFormEdit(ModelDatabase modelDatabase) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PageInputPengeluaran(modelDatabase: modelDatabase)));
    if (result == 'update') {
      await getAllData();
      await getJmlUang();
      await getDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Widget untuk menampilkan total pengeluaran
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Pengeluaran Bulan Ini',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600])),
                    SizedBox(height: 8),
                    Text(
                      CurrencyFormat.convertToIdr(strJmlUang),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Menampilkan pesan jika tidak ada data, atau list data jika ada
            strCheckDatabase == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada pengeluaran.\nYuk catat pengeluaran Kamu!',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listPemasukan.length,
                    itemBuilder: (context, index) {
                      ModelDatabase modeldatabase = listPemasukan[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            '${modeldatabase.keterangan}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                CurrencyFormat.convertToIdr(int.parse(
                                    modeldatabase.jml_uang.toString())),
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('${modeldatabase.tanggal}',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => openFormEdit(modeldatabase),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _showDeleteDialog(modeldatabase, index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      // Tombol floating untuk menambah data pengeluaran baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openFormCreate,
        icon: Icon(Icons.add),
        label: Text('Tambah Pengeluaran'),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi penghapusan data
  void _showDeleteDialog(ModelDatabase modeldatabase, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Data'),
        content: Text('Yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            child: Text('Tidak'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Ya'),
            onPressed: () {
              deleteData(modeldatabase, index);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
