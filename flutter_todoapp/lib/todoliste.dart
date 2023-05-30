import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/database_helper.dart';

import 'models/todomodel.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
 // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
TextEditingController _searchController = TextEditingController();
bool _isSearching = false;

  final List<Todo> _todoList = [];
   List<Todo> _searchResults =[];
bool _sortByDate = false;

  Future<void> _addTodo() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    bool etat ;
   
    if (pickedDate != null) {
      setState(() {

        Todo newTodo = Todo(
          
          title: _titleController.text,
          description: _descriptionController.text,
          etat: false,
          date: pickedDate,
          
        );

        // ignore: unnecessary_cast
        DatabaseHelper.addTodo(newTodo);
        _todoList.add(newTodo);

        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _deleteTodo(int index) async {
    Todo todoToDelete = _todoList[index];
    await DatabaseHelper.delete(todoToDelete);

    setState(() {
      _todoList.removeAt(index);
    });
  }

  void _toggleTodoDone(int index) async {
    Todo todoToUpdate = _todoList[index];
    todoToUpdate.etat = !todoToUpdate.etat;
    await DatabaseHelper.update(todoToUpdate);

    setState(() {
      _todoList[index] = todoToUpdate;
    });
  }

  void _showTodoDetails(Todo todo) {
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    _dateController.text = DateFormat('yyyy-MM-dd').format(todo.date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(todo.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                todo.title = _titleController.text;
                todo.description = _descriptionController.text;
                todo.date = DateFormat('yyyy-MM-dd').parse(_dateController.text);

                await DatabaseHelper.update(todo);

                setState(() {
                  // No need to update the state as we are modifying the existing todo object
                });

                Navigator.pop(context);
              },
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }
  Future<void> _loadTodoList() async {
  List<Todo>? todos = await DatabaseHelper.alltodo();

  if (todos != null) {
    setState(() {
      _todoList.addAll(todos);
      _searchResults.addAll(todos);
     
    });
  }
}
Widget _buildSearchField() {
  return TextField(
    controller: _searchController,
    decoration: InputDecoration(
      labelText: 'Search',
      prefixIcon: Icon(Icons.search),
    ),
    onChanged: (value) {
      setState(() {
        _searchResults = _todoList
            .where((todo) => todo.title.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    },
  );
}




  

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: _isSearching ? _buildSearchField() : Text('Todo App'),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('lib/assets/logo.png'),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              _searchController.clear();
            });
          },
        ),
      ],
    ),
    body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _todoList.length,
            itemBuilder: (BuildContext context, int index) {
              final Todo todo = _todoList[index];
              return Dismissible(
                key: Key('${todo.title}${todo.date}${todo.etat}'),
                onDismissed: (direction) {
                  _deleteTodo(index);
                },
                child: ListTile(
                  onTap: () {
                    _showTodoDetails(todo);
                  },
                  leading: Checkbox(
                    value: todo.etat,
                    onChanged: (bool? value) {
                      _toggleTodoDone(index);
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.etat ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('yyyy-MM-dd').format(todo.date)),
                      SizedBox(height: 8),
                      Text(todo.description),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _addTodo,
      tooltip: 'Add Todo',
      child: Icon(Icons.add),
    ),
  );
}

}

