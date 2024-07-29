// Import paket-paket yang diperlukan
import 'package:CatatanKu/model/model_database.dart';
import 'package:CatatanKu/database/DatabaseHelper2.dart';
import 'package:CatatanKu/catatan/detailcatatan.dart';
import 'package:flutter/material.dart';

// Widget StatefulWidget untuk halaman catatan
class PageCatatan extends StatefulWidget {
  const PageCatatan({super.key});

  @override
  State<PageCatatan> createState() => _PageCatatanState();
}

// State untuk PageCatatan
class _PageCatatanState extends State<PageCatatan> {
  // List untuk menyimpan catatan-catatan
  List<ModelCatatan> _notes = [];

  @override
  void initState() {
    super.initState();
    // Memuat catatan saat widget diinisialisasi
    _loadNotes();
  }

  // Fungsi untuk memuat catatan dari database
  Future<void> _loadNotes() async {
    final notes = await DatabaseHelper2().getAllNotes();
    setState(() {
      // Mengubah hasil query menjadi list ModelCatatan
      _notes = notes.map((note) => ModelCatatan.fromMap(note)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _notes.isEmpty
          // Tampilan jika tidak ada catatan
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada catatan.\nYuk buat catatan baru!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          // Tampilan list catatan jika ada catatan
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      note.title ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.date ?? '',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    // Navigasi ke halaman detail catatan saat item ditekan
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCatatanPage(note: note),
                        ),
                      ).then((_) =>
                          _loadNotes()); // Memuat ulang catatan setelah kembali
                    },
                  ),
                );
              },
            ),
      // Tombol floating untuk menambah catatan baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke halaman detail catatan untuk membuat catatan baru
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailCatatanPage(),
            ),
          ).then((_) => _loadNotes()); // Memuat ulang catatan setelah kembali
        },
        icon: Icon(Icons.add),
        label: Text('Tambah Catatan'),
        backgroundColor: Colors.yellow[300],
        foregroundColor: Colors.black87,
      ),
    );
  }
}
