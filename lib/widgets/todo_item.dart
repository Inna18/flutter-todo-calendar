import 'package:flutter/material.dart';
import 'package:todo_calendar_app/models/todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({required this.todoItem, super.key});

  final Todo todoItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Text(formatter.format(todoItem.date)),
                const Spacer(flex: 1),
                Text(todoItem.categoty.name.toUpperCase())
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [Text(todoItem.content)],
            )
          ],
        ),
      ),
    );
  }
}
