import 'package:flutter/material.dart';
import 'package:CatatanKu/database/database_helper.dart';
import 'package:CatatanKu/model/todo.dart';

class TodoDrawer extends StatefulWidget {
  const TodoDrawer({Key? key}) : super(key: key);

  @override
  _TodoDrawerState createState() => _TodoDrawerState();
}

class _TodoDrawerState extends State<TodoDrawer> {
  final List<ToDo> _todoItems = [];
  final TextEditingController _textFieldController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  Future<void> _loadTodoItems() async {
    final loadedItems = await _dbHelper.getToDos();
    setState(() {
      _todoItems
        ..clear()
        ..addAll(loadedItems);
    });
  }

  Future<void> _addTodoItem(String task) async {
    if (task.isNotEmpty) {
      final newTodo = ToDo(task: task);
      await _dbHelper.insertToDo(newTodo);
      _textFieldController.clear();
      await _loadTodoItems();
    }
  }

  Future<void> _removeTodoItem(int id) async {
    await _dbHelper.deleteToDo(id);
    await _loadTodoItems();
  }

  Future<void> _toggleTodoItem(ToDo todo) async {
    todo.isCompleted = !todo.isCompleted;
    await _dbHelper.updateToDo(todo);
    await _loadTodoItems();
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        final todo = _todoItems[index];
        return TodoListTile(
          todo: todo,
          onToggle: _toggleTodoItem,
          onDelete: () => _removeTodoItem(todo.id!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow[300],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Tugas',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_todoItems.length} tugas',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TodoInputField(
              controller: _textFieldController,
              onSubmitted: _addTodoItem,
            ),
          ),
          Expanded(
            child: _todoItems.isEmpty
                ? const Center(child: Text('Belum ada tugas'))
                : _buildTodoList(),
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

class TodoListTile extends StatelessWidget {
  final ToDo todo;
  final VoidCallback onDelete;
  final Function(ToDo) onToggle;

  const TodoListTile({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(todo),
          activeColor: Colors.green,
        ),
        title: Text(
          todo.task,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class TodoInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const TodoInputField({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Tambah tugas baru',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: () => onSubmitted(controller.text),
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
