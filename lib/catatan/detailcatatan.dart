import 'package:flutter/material.dart';
import 'package:catatanku/model/model_database.dart';
import 'package:catatanku/database/DatabaseHelper2.dart';

class DetailCatatanPage extends StatefulWidget {
  final ModelCatatan? note;

  const DetailCatatanPage({super.key, this.note});

  @override
  _DetailCatatanPageState createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _content;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newNote = ModelCatatan(
        id: widget.note?.id,
        title: _title,
        content: _content,
        date: DateTime.now().toIso8601String(),
      );

      if (widget.note == null) {
        await DatabaseHelper().saveNote(newNote);
      } else {
        await DatabaseHelper().updateNote(newNote);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _deleteNote() async {
    if (widget.note != null) {
      await DatabaseHelper().deleteNote(widget.note!.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
          actions: [
            if (widget.note != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: _deleteNote,
              ),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Simpan'),
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
                    ),
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
                    ),
                    // SizedBox(height: 20),

                    // ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
