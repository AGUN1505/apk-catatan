// Import paket-paket yang diperlukan
import 'package:flutter/material.dart';
import 'package:CatatanKu/database/DatabaseHelper.dart';
import 'package:CatatanKu/model/model_database.dart';
import 'package:intl/intl.dart';

// Widget StatefulWidget untuk halaman input pengeluaran
class PageInputPengeluaran extends StatefulWidget {
  final ModelDatabase? modelDatabase;

  // Constructor dengan parameter opsional modelDatabase
  PageInputPengeluaran({this.modelDatabase});

  @override
  _PageInputPengeluaranState createState() => _PageInputPengeluaranState();
}

// State untuk PageInputPengeluaran
class _PageInputPengeluaranState extends State<PageInputPengeluaran> {
  // Inisialisasi DatabaseHelper untuk operasi database
  DatabaseHelper databaseHelper = DatabaseHelper();

  // Controller untuk input teks
  TextEditingController? keterangan;
  TextEditingController? tanggal;
  TextEditingController? jml_uang;

  @override
  void initState() {
    // Inisialisasi controller dengan nilai dari modelDatabase jika ada
    keterangan = TextEditingController(
        text: widget.modelDatabase == null
            ? ''
            : widget.modelDatabase!.keterangan);
    tanggal = TextEditingController(
        text:
            widget.modelDatabase == null ? '' : widget.modelDatabase!.tanggal);
    jml_uang = TextEditingController(
        text:
            widget.modelDatabase == null ? '' : widget.modelDatabase!.jml_uang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul dan warna latar
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        backgroundColor: Colors.yellow[300],
        title: Text('Form Data Pengeluaran',
            style: TextStyle(fontSize: 16, color: Colors.black87)),
      ),
      // Body berisi ListView dengan form input
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // TextField untuk input keterangan
          TextField(
            controller: keterangan,
            decoration: InputDecoration(
              labelText: 'Keterangan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.yellow[50],
            ),
          ),
          SizedBox(height: 16),
          // TextField untuk input tanggal dengan DatePicker
          TextField(
            controller: tanggal,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(9999),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme:
                          ColorScheme.light(primary: Colors.yellow[300]!),
                      buttonTheme:
                          ButtonThemeData(textTheme: ButtonTextTheme.primary),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                tanggal!.text = DateFormat('dd MMM yyyy').format(pickedDate);
              }
            },
            decoration: InputDecoration(
              labelText: 'Tanggal',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.yellow[50],
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
          SizedBox(height: 16),
          // TextField untuk input jumlah uang
          TextField(
            controller: jml_uang,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah Uang',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.yellow[50],
              prefixText: 'Rp ',
            ),
          ),
          SizedBox(height: 24),
          // Tombol untuk menyimpan atau mengupdate data
          ElevatedButton(
            onPressed: () {
              // Validasi input sebelum menyimpan
              if (keterangan!.text.isEmpty ||
                  tanggal!.text.isEmpty ||
                  jml_uang!.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Semua field harus diisi!")),
                );
              } else {
                upsertData();
              }
            },
            child: Text(
              widget.modelDatabase == null ? 'Tambah Data' : 'Update Data',
              style: TextStyle(color: Colors.black87),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[300],
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menyimpan atau mengupdate data
  Future<void> upsertData() async {
    if (widget.modelDatabase != null) {
      // Update data jika modelDatabase tidak null
      await databaseHelper.updateDataPengeluaran(ModelDatabase.fromMap({
        'id': widget.modelDatabase!.id,
        'tipe': 'pengeluaran',
        'keterangan': keterangan!.text,
        'jml_uang': jml_uang!.text,
        'tanggal': tanggal!.text
      }));
      Navigator.pop(context, 'update');
    } else {
      // Insert data baru jika modelDatabase null
      await databaseHelper.saveData(ModelDatabase(
        tipe: 'pengeluaran',
        keterangan: keterangan!.text,
        jml_uang: jml_uang!.text,
        tanggal: tanggal!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }
}
