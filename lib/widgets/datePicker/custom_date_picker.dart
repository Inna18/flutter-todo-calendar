import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({required this.defaultDate, required this.selectDate});

  final DateTime? defaultDate;
  final void Function(DateTime date) selectDate;

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
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.defaultDate ?? DateTime.now();
    firstDay = prevMLastWeekday == 6
        ? 0
        : DateTime(DateTime.now().year, DateTime.now().month, 0).day -
            prevMLastWeekday;
    lastDay =
        7 - (DateTime(DateTime.now().year, DateTime.now().month + 1).weekday);
    setCalendar();
  }

  void setCalendar() {
    List<int> prevMonth = [];
    List<int> currentMonth = [];
    List<int> nextMonth = [];

    if (firstDay != 0) {
      for (int i = firstDay; i <= prevMLastDay; i++) {
        prevMonth.add(i);
      }
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
    void rerenderDates() {
      prevMLastDay = (DateTime(_today.year, _today.month, 0).day);
      currentMLastDay = (DateTime(_today.year, _today.month + 1, 0).day);
      prevMLastWeekday = (DateTime(_today.year, _today.month, 0).weekday) % 7;
      currentMFirstWeekday = (DateTime(_today.year, _today.month).weekday) % 7;
      firstDay = prevMLastWeekday == 6
          ? 0
          : DateTime(_today.year, _today.month, 0).day - prevMLastWeekday;
      lastDay = 7 - (DateTime(_today.year, _today.month + 1).weekday);
    }

    void toPrevMonth() {
      setState(() {
        // change current date (month) to previous
        if (_today.month == 1) {
          _today = DateTime(_today.year - 1, 12);
        } else {
          _today = DateTime(_today.year, _today.month - 1);
        }
        rerenderDates();
      });
      setCalendar();
    }

    void toNextMonth() {
      setState(() {
        // change current date (month) to next
        if (DateTime.now().month == 12) {
          _today = DateTime(_today.year + 1, 1);
        } else {
          _today = DateTime(_today.year, _today.month + 1);
        }
        rerenderDates();
      });
      setCalendar();
    }

    bool isToday(int day) {
      return _today.month == DateTime.now().month && DateTime.now().day == day;
    }

    void setSelectedDate(int type, int day) {
      if (type == 0) {
        _selectedDate = DateTime(_today.year, _today.month - 1, day);
      } else if (type == 1) {
        _selectedDate = DateTime(_today.year, _today.month, day);
      } else {
        _selectedDate = DateTime(_today.year, _today.month + 1, day);
      }

      widget.selectDate(_selectedDate!);
    }

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: toPrevMonth,
                icon: const Icon(
                  Icons.chevron_left,
                )),
            Text(
              DateFormat('yyyy.MM').format(_today),
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
                onPressed: toNextMonth,
                icon: const Icon(
                  Icons.chevron_right,
                )),
          ]),
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
              ...calendar[0].map((day) => GestureDetector(
                    // prevMonth dates
                    onTap: () {
                      setSelectedDate(0, day);
                      setState(() {
                        isSelected = false;
                        isSelected = true;
                      });
                    },
                    child: Container(
                        height: 32,
                        width: 36,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: isSelected &&
                                _selectedDate!.month == _today.month - 1 &&
                                day == _selectedDate!.day
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue[100])
                            : const BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        )),
                  )),
              ...calendar[1].map((day) => GestureDetector(
                    // currentMonth dates
                    onTap: () {
                      setSelectedDate(1, day);
                      setState(() {
                        isSelected = false;
                        isSelected = true;
                      });
                    },
                    child: Container(
                        height: 32,
                        width: 36,
                        decoration: isSelected &&
                                _selectedDate!.month == _today.month &&
                                day == _selectedDate!.day
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue[100])
                            : const BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                        child: Align(
                            alignment: Alignment.center,
                            child: isToday(day)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                33, 150, 243, 1))),
                                    child: Text(day.toString()),
                                  )
                                : Text(day.toString()))),
                  )),
              ...calendar[2].map((day) => GestureDetector(
                    // nextMonth dates
                    onTap: () {
                      setSelectedDate(2, day);
                      setState(() {
                        isSelected = false;
                        isSelected = true;
                      });
                    },
                    child: Container(
                        height: 32,
                        width: 36,
                        decoration: isSelected &&
                                _selectedDate!.month == _today.month + 1 &&
                                day == _selectedDate!.day
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue[100])
                            : const BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            day.toString(),
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        )),
                  )),
            ],
          )),
        ],
      ),
    );
  }
}
