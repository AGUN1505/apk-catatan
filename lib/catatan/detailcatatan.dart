// Import paket-paket yang diperlukan
import 'package:flutter/material.dart';
import 'package:CatatanKu/model/model_database.dart';
import 'package:CatatanKu/database/DatabaseHelper2.dart';

// Widget StatefulWidget untuk halaman detail catatan
class DetailCatatanPage extends StatefulWidget {
  final ModelCatatan? note; // Catatan yang akan ditampilkan/diedit (opsional)

  const DetailCatatanPage({super.key, this.note});

  @override
  _DetailCatatanPageState createState() => _DetailCatatanPageState();
}

// State untuk DetailCatatanPage
class _DetailCatatanPageState extends State<DetailCatatanPage> {
  final _formKey = GlobalKey<FormState>(); // Key untuk form
  String? _title; // Judul catatan
  String? _content; // Isi catatan
  bool _isModified = false; // Tambahkan variabel untuk melacak perubahan

  @override
  void initState() {
    super.initState();
    // Inisialisasi judul dan isi jika catatan sudah ada
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
    }
  }

  // Fungsi untuk autosave
  Future<void> _autoSaveNote() async {
    if (_isModified && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newNote = ModelCatatan(
        id: widget.note?.id,
        title: _title,
        content: _content,
        date: DateTime.now().toIso8601String(),
      );
      if (widget.note == null) {
        await DatabaseHelper2().saveNote(newNote);
      } else {
        await DatabaseHelper2().updateNote(newNote);
      }
      // Opsional: tambahkan log atau notifikasi bahwa autosave telah dilakukan
      print('Catatan disimpan otomatis');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _autoSaveNote(); // Panggil autosave sebelum keluar halaman
        return true; // Izinkan navigasi kembali
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
          actions: [
            // Tombol hapus hanya ditampilkan jika mengedit catatan yang sudah ada
            if (widget.note != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: _deleteNote,
              ),
            // Tombol simpan
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveNote,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Input field untuk judul catatan
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(labelText: 'Judul'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value,
                      onChanged: (value) {
                        _title = value;
                        _isModified = true; // Tandai bahwa ada perubahan
                      },
                    ),
                    // Input field untuk isi catatan
                    TextFormField(
                      initialValue: _content,
                      decoration: InputDecoration(labelText: 'Isi'),
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi tidak boleh kosong';
                        }
                        return null;
                      },
                      onSaved: (value) => _content = value,
                      onChanged: (value) {
                        _content = value;
                        _isModified = true; // Tandai bahwa ada perubahan
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // Fungsi untuk menyimpan catatan
  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Membuat objek catatan baru
      final newNote = ModelCatatan(
        id: widget.note?.id,
        title: _title,
        content: _content,
        date: DateTime.now().toIso8601String(),
      );

      // Menyimpan catatan baru atau memperbarui catatan yang ada
      if (widget.note == null) {
        await DatabaseHelper2().saveNote(newNote);
      } else {
        await DatabaseHelper2().updateNote(newNote);
      }

      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }
  }

  // Fungsi untuk menghapus catatan
  Future<void> _deleteNote() async {
    if (widget.note != null) {
      await DatabaseHelper2().deleteNote(widget.note!.id!);
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }
  }
}
