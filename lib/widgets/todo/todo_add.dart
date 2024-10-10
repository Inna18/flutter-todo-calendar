import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_calendar_app/models/todo.dart';
import 'package:todo_calendar_app/widgets/datePicker/custom_date_picker.dart';

class TodoAdd extends StatefulWidget {
  const TodoAdd({required this.onAdd, super.key});

  final void Function(Todo todo) onAdd;

  @override
  State<StatefulWidget> createState() {
    return _TodoAddState();
  }
}

class _TodoAddState extends State<TodoAdd> {
  List<DateTime> _selectedDates = [DateTime.now()];
  Category _selectedCategory = Category.daily;
  final _contentController = TextEditingController();

  void _addTodo() {
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

    final newTodo = Todo(
        id: uuid.v4(),
        content: _contentController.text,
        date: _selectedDates[0],
        category: _selectedCategory);

    widget.onAdd(newTodo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(Localizations.localeOf(context).languageCode);

    final config = CalendarDatePicker2Config(
        selectedDayHighlightColor: Colors.blue[400],
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        firstDayOfWeek: 1,
        controlsHeight: 50,
        dayMaxWidth: 25,
        animateToDisplayedMonthDate: true,
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        dayTextStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        disabledDayTextStyle: const TextStyle(
          color: Colors.grey,
        ),
        centerAlignModePicker: true,
        useAbbrLabelForMonthModePicker: true,
        modePickersGap: 0,
        modePickerTextHandler: ({required monthDate, isMonthPicker}) {
          if (isMonthPicker ?? false) {
            // Custom month picker text
            return '${getLocaleShortMonthFormat(const Locale('en')).format(monthDate)} C';
          }
          return null;
        },
        firstDate: DateTime.now());

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
                      // child: CalendarDatePicker2(
                      //   config: config,
                      //   value: [DateTime.now()],
                      //   onValueChanged: (value) {
                      //     _selectedDates = value;
                      //   },
                      // ),
                      child: CustomDatePicker(
                        selectedDate: DateTime.now(),
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
                ElevatedButton(onPressed: _addTodo, child: const Text('Save'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
