import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { daily, work, study }

class Todo {
  Todo({required this.id, required this.content, required this.date, required this.category});
  final String id;
  final String content;
  final DateTime date;
  final Category category;
}
