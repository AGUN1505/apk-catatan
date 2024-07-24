import 'package:catatanku/model/model_database.dart';
import 'package:catatanku/database/DatabaseHelper2.dart';
import 'package:catatanku/catatan/detailcatatan.dart';
import 'package:flutter/material.dart';

class PageCatatan extends StatefulWidget {
  const PageCatatan({super.key});

  @override
  State<PageCatatan> createState() => _PageCatatanState();
}

class _PageCatatanState extends State<PageCatatan> {
  List<ModelCatatan> _notes = [];
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseHelper().getAllNotes();
    setState(() {
      _notes = notes.map((note) => ModelCatatan.fromMap(note)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true, // Add this line
              physics: const NeverScrollableScrollPhysics(), // Add this line
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note.title ?? ''),
                  subtitle: Text(note.date ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailCatatanPage(note: note),
                      ),
                    ).then((_) => _loadNotes());
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailCatatanPage(),
            ),
          ).then((_) => _loadNotes());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
