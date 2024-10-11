import 'package:flutter/material.dart';
import 'package:todo_calendar_app/models/todo.dart';
import 'package:todo_calendar_app/widgets/datePicker/custom_date_picker.dart';

class TodoEdit extends StatefulWidget {
  const TodoEdit({required this.item, required this.onEditTodo, super.key});

  final Todo item;
  final void Function(Todo editedTodo) onEditTodo;

  @override
  State<StatefulWidget> createState() {
    return _TodoEditState();
  }
}

class _TodoEditState extends State<TodoEdit> {
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.daily;
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.item.date;
    _selectedCategory = widget.item.category;
    _contentController.text = widget.item.content;
  }

  void _editTodo() {
    if (_contentController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Error'),
                content: const Text('To do field is empty.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Ok'),
                  )
                ],
              ));
      return;
    }

    final editedTodo = Todo(
        id: widget.item.id,
        content: _contentController.text,
        date: _selectedDate,
        category: _selectedCategory);

    widget.onEditTodo(editedTodo);
    Navigator.pop(context);
  }

  void selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add New To Do",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300,
                      child: CustomDatePicker(
                        defaultDate: _selectedDate,
                        selectDate: selectDate,
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            '${category.name[0].toUpperCase()}${category.name.substring(1)}',
                            style: TextStyle(color: Colors.grey[700]),
                          )))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    } else {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('To Do')),
                    controller: _contentController,
                  ),
                )
              ],
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                ElevatedButton(onPressed: _editTodo, child: const Text('Edit'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
