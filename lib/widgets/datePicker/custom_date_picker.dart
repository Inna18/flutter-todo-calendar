import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({required this.selectedDate});

  final DateTime? selectedDate;

  @override
  State<StatefulWidget> createState() {
    return _CustomDatePickerState();
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  DateTime _today = DateTime.now();
  DateTime? _selectedDate = DateTime.now();
  // Sunday = 0
  int prevMLastDay =
      (DateTime(DateTime.now().year, DateTime.now().month, 0).day);
  int currentMLastDay =
      (DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day);
  int prevMLastWeekday =
      (DateTime(DateTime.now().year, DateTime.now().month, 0).weekday) % 7;
  int currentMFirstWeekday =
      (DateTime(DateTime.now().year, DateTime.now().month).weekday) % 7;
  int firstDay = 0;
  int lastDay = 0;
  List<List<int>> calendar = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    firstDay = prevMLastWeekday == 6
        ? 0
        : DateTime(DateTime.now().year, DateTime.now().month, 0).day -
            prevMLastWeekday;
    lastDay =
        7 - (DateTime(DateTime.now().year, DateTime.now().month + 1).weekday);
  }

  void setCalendar() {
    List<int> prevMonth = [];
    List<int> currentMonth = [];
    List<int> nextMonth = [];

    for (int i = firstDay; i <= prevMLastDay; i++) {
      prevMonth.add(i);
    }
    for (int i = 1; i <= currentMLastDay; i++) {
      currentMonth.add(i);
    }
    for (int i = 1; i <= lastDay; i++) {
      nextMonth.add(i);
    }
    setState(() {
      calendar = [prevMonth, currentMonth, nextMonth];
    });
  }

  @override
  Widget build(BuildContext context) {
    setCalendar();

    return Container(
      child: Column(
        children: [
          Text(
            DateFormat('yyyy.MM').format(_today),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
              // Weekdays
              child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: weekdays
                .map((weekday) => SizedBox(
                    height: 32,
                    width: 36,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(weekday,
                          style: weekday == 'Sat' || weekday == 'Sun'
                              ? TextStyle(color: Colors.red[300])
                              : TextStyle(color: Colors.blue[500])),
                    )))
                .toList(),
          )),
          Center(
              // Dates
              child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: [
              ...calendar[0].map((day) => SizedBox(
                  height: 32,
                  width: 36,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      day.toString(),
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ))),
              ...calendar[1].map((day) => SizedBox(
                  height: 32,
                  width: 36,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      day.toString(),
                    ),
                  ))),
              ...calendar[2].map((day) => SizedBox(
                  height: 32,
                  width: 36,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      day.toString(),
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ))),
            ],
          )),
        ],
      ),
    );
  }
}
