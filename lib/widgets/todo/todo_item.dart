import 'package:flutter/material.dart';
import 'package:todo_calendar_app/models/todo.dart';
import 'package:todo_calendar_app/widgets/todo/todo_edit.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({required this.todoItem, required this.onEditTodo, super.key});

  final Todo todoItem;
  final void Function(Todo editTodo) onEditTodo;

  @override
  State<StatefulWidget> createState() {
    return _TodoItemState();
  }
}

class _TodoItemState extends State<TodoItem> {
  
  void _openEditOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => TodoEdit(item: widget.todoItem, onEditTodo: widget.onEditTodo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(formatter.format(widget.todoItem.date)),
                const SizedBox(
                  width: 32,
                ),
                Text(widget.todoItem.category.name.toUpperCase()),
                const Spacer(flex: 1),
                IconButton(
                    onPressed: _openEditOverlay,
                    icon: const Icon(
                      Icons.edit,
                    ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [Text(widget.todoItem.content)],
            )
          ],
        ),
      ),
    );
  }
}
