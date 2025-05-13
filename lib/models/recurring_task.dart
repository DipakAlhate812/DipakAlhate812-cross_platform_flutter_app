import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// Task  Model
class MasterTask {
  final String title;
  final String recurrence;

  MasterTask({required this.title, required this.recurrence});

  factory MasterTask.fromParse(ParseObject obj) {
    return MasterTask(
      title: obj.get<String>('taskTitle') ?? '',
      recurrence: obj.get<String>('taskType') ?? 'Weekly',
    );
  }
}

