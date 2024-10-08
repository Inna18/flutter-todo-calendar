import 'package:flutter/material.dart';
import 'package:todo_calendar_app/models/todo.dart';
import 'package:todo_calendar_app/widgets/todo_item.dart';

class TodosList extends StatelessWidget {
  const TodosList({required this.todos, required this.onRemoveTodo, required this.onEditTodo, super.key});

  final List<Todo> todos;
  final void Function(Todo removeTodo) onRemoveTodo;
  final void Function(Todo editTodo) onEditTodo;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              vertical: 8),
        ),
        key: ValueKey(todos[index]),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onRemoveTodo(todos[index]),
        child: TodoItem(todoItem: todos[index], onEditTodo: onEditTodo),
      ),
    );
  }
}
