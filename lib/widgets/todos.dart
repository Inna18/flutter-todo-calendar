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
        id: uuid.v4(),
        content: 'Grosery Shopping',
        date: DateTime.now(),
        category: Category.daily),
    Todo(
        id: uuid.v4(),
        content: 'Prepare Event',
        date: DateTime.now(),
        category: Category.work),
    Todo(
        id: uuid.v4(),
        content: 'Study Lectures',
        date: DateTime.now(),
        category: Category.study),
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

  void _removeTodo(Todo removeTodo) {
    final indexOfTodo = todos.indexOf(removeTodo);

    setState(() {
      todos.remove(removeTodo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Task deleted.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            todos.insert(indexOfTodo, removeTodo);
          });
        },
      ),
    ));
  }

  void _editTodo(Todo editedTodo) {
    final editTodo = todos.where((todo) => todo.id == editedTodo.id).first;
    final index = todos.indexOf(editTodo);
    setState(() {
      todos.remove(editTodo);
      todos.insert(index, editedTodo);
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
                todos: todos, onRemoveTodo: _removeTodo, onEditTodo: _editTodo),
          ),
        ],
      ),
    );
  }
}
