// Import paket-paket yang diperlukan
import 'package:flutter/material.dart';
import 'package:CatatanKu/database/DatabaseHelper.dart';
import 'package:CatatanKu/decoration/format_rupiah.dart';
import 'package:CatatanKu/model/model_database.dart';
import 'package:CatatanKu/pemasukan/page_input_pemasukan.dart';

// Widget StatefulWidget untuk halaman pemasukan
class PagePemasukan extends StatefulWidget {
  const PagePemasukan({Key? key}) : super(key: key);

  @override
  State<PagePemasukan> createState() => _PagePemasukanState();
}

// State untuk PagePemasukan
class _PagePemasukanState extends State<PagePemasukan> {
  // List untuk menyimpan data pemasukan
  List<ModelDatabase> listPemasukan = [];
  // Objek DatabaseHelper untuk operasi database
  DatabaseHelper databaseHelper = DatabaseHelper();
  // Variabel untuk menyimpan jumlah total pemasukan
  int strJmlUang = 0;
  // Variabel untuk mengecek apakah database kosong atau tidak
  int strCheckDatabase = 0;

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
    var checkDB = await databaseHelper.cekDataPemasukan();
    setState(() {
      if (checkDB == 0) {
        strCheckDatabase = 0;
        strJmlUang = 0;
      } else {
        strCheckDatabase = checkDB!;
      }
    });
  }

  // Fungsi untuk mendapatkan jumlah total pemasukan
  Future<void> getJmlUang() async {
    var checkJmlUang = await databaseHelper.getJmlPemasukan();
    setState(() {
      if (checkJmlUang == 0) {
        strJmlUang = 0;
      } else {
        strJmlUang = checkJmlUang;
      }
    });
  }

  // Fungsi untuk mendapatkan semua data pemasukan dan menampilkannya di ListView
  Future<void> getAllData() async {
    var listData = await databaseHelper.getDataPemasukan();
    setState(() {
      listPemasukan.clear();
      listData!.forEach((kontak) {
        listPemasukan.add(ModelDatabase.fromMap(kontak));
      });
    });
  }

  // Fungsi untuk menghapus data berdasarkan Id
  Future<void> deleteData(ModelDatabase modelDatabase, int position) async {
    await databaseHelper.deletePemasukan(modelDatabase.id!);
    setState(() {
      getJmlUang();
      getDatabase();
      listPemasukan.removeAt(position);
    });
  }

  // Fungsi untuk membuka form input data baru
  Future<void> openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PageInputPemasukan()));
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
                PageInputPemasukan(modelDatabase: modelDatabase)));
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
            // Widget Card untuk menampilkan total pemasukan
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Pemasukan Bulan Ini',
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
            // Kondisi untuk menampilkan pesan jika tidak ada data atau ListView jika ada data
            strCheckDatabase == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada pemasukan.\nYuk catat pemasukan Kamu!',
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
      // Tombol floating untuk menambah data pemasukan baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openFormCreate,
        icon: Icon(Icons.add),
        label: Text('Tambah Pemasukan'),
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
