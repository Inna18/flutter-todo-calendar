import 'package:flutter/material.dart';
import 'package:todo_calendar_app/models/todo.dart';
import 'package:todo_calendar_app/widgets/todo_add.dart';
import 'package:todo_calendar_app/widgets/todos_list.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodoState();
  }
}

class _TodoState extends State<Todos> {
  List<Todo> todos = [
    Todo(
        content: 'Grosery Shopping',
        date: DateTime.now(),
        categoty: Category.daily),
    Todo(
        content: 'Prepare Event',
        date: DateTime.now(),
        categoty: Category.work),
    Todo(
        content: 'Study Lectures',
        date: DateTime.now(),
        categoty: Category.study),
  ];

  void _openAddOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => TodoAdd(onAdd: _addTodo),
    );
  }

  void _addTodo(Todo newTodo) {
    setState(() {
      todos.add(newTodo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          IconButton(onPressed: _openAddOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TodosList(
              todos: todos,
            ),
          ),
        ],
      ),
    );
  }
}
