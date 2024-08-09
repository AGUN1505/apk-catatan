import 'package:flutter/material.dart';
import 'package:CatatanKu/database/database_helper.dart';
import 'package:CatatanKu/model/todo.dart';

class TodoDrawer extends StatefulWidget {
  @override
  _TodoDrawerState createState() => _TodoDrawerState();
}

class _TodoDrawerState extends State<TodoDrawer> {
  List<ToDo> _todoItems = [];
  TextEditingController _textFieldController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  _loadTodoItems() async {
    _todoItems = await _dbHelper.getToDos();
    setState(() {});
  }

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      final newTodo = ToDo(task: task);
      _dbHelper.insertToDo(newTodo);
      _textFieldController.clear();
      _loadTodoItems();
    }
  }

  void _removeTodoItem(int id) {
    _dbHelper.deleteToDo(id);
    _loadTodoItems();
  }

  void _toggleTodoItem(ToDo todo) {
    todo.isCompleted = !todo.isCompleted;
    _dbHelper.updateToDo(todo);
    _loadTodoItems();
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        final todo = _todoItems[index];
        return ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (bool? value) {
              _toggleTodoItem(todo);
            },
          ),
          title: Text(
            todo.task,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeTodoItem(todo.id!),
          ),
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
                  },
                ),
              ),
              onSubmitted: (value) {
                _addTodoItem(value);
              },
            ),
          ),
          Expanded(
            child: _buildTodoList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
