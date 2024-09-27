import 'package:flutter/material.dart';
import 'package:todo_calendar_app/models/todo.dart';
import 'package:todo_calendar_app/widgets/todo_item.dart';

class TodosList extends StatelessWidget {
  const TodosList({required this.todos, super.key});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) => TodoItem(todoItem: todos[index]));
  }
}
