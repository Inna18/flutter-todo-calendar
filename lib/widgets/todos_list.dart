import 'package:flutter/material.dart';
import 'package:todo_calendar_app/models/todo.dart';

class TodosList extends StatelessWidget {
  TodosList({required this.todos, super.key});

  List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) => Text(todos[index].content));
  }
}
