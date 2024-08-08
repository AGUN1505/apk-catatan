import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoDrawer extends StatefulWidget {
  @override
  _TodoDrawerState createState() => _TodoDrawerState();
}

class _TodoDrawerState extends State<TodoDrawer> {
  List<Map<String, dynamic>> _todoItems = [];
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  _loadTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems = (prefs.getStringList('todoItems') ?? []).map((item) {
        final parts = item.split('|');
        return {
          'task': parts[0],
          'isCompleted': parts[1] == 'true',
        };
      }).toList();
    });
  }

  _saveTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'todoItems',
        _todoItems
            .map((item) => '${item['task']}|${item['isCompleted']}')
            .toList());
  }

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add({'task': task, 'isCompleted': false});
      });
      _saveTodoItems();
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
    _saveTodoItems();
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index]['isCompleted'] = !_todoItems[index]['isCompleted'];
    });
    _saveTodoItems();
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus "${_todoItems[index]['task']}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('BATAL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('HAPUS'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Checkbox(
            value: _todoItems[index]['isCompleted'],
            onChanged: (bool? value) {
              _toggleTodoItem(index);
            },
          ),
          title: Text(
            _todoItems[index]['task'],
            style: TextStyle(
              decoration: _todoItems[index]['isCompleted']
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          onTap: () => _promptRemoveTodoItem(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.yellow[300],
            ),
            child: Center(
              child: Text(
                'Daftar Tugas',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildTodoList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                labelText: 'Tambah tugas baru',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addTodoItem(_textFieldController.text);
                    _textFieldController.clear();
                  },
                ),
              ),
              onSubmitted: (value) {
                _addTodoItem(value);
                _textFieldController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
