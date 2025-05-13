import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter/material.dart';

// Task provider screen for add task screen
class TaskProvider with ChangeNotifier {
  List<ParseObject> _tasks = [];
  List<ParseObject> get tasks => _tasks;

  Future<void> fetchTasks() async {
    final query = QueryBuilder<ParseObject>(ParseObject('masterTasks'));
    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      _tasks = response.results!.cast<ParseObject>();
      notifyListeners();
    } else {
      print('Error fetching tasks: ${response.error?.message}');
    }
  }

  Future<void> addTask(String taskTitle, String taskType) async {
    final task = ParseObject('masterTasks')
      ..set('taskTitle', taskTitle)
      ..set('taskType', taskType);

    final ParseResponse response = await task.save();

    if (response.success) {
      _tasks.add(response.result as ParseObject);
      notifyListeners();
    } else {
      print('Error adding task: ${response.error?.message}');
    }
  }

  Future<void> updateTask(String objectId, String taskTitle, String taskType) async {
    final task = ParseObject('masterTasks')
      ..objectId = objectId
      ..set('taskTitle', taskTitle)
      ..set('taskType', taskType);

    final ParseResponse response = await task.save();

    if (response.success) {
      final index = _tasks.indexWhere((t) => t.objectId == objectId);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } else {
      print('Error updating task: ${response.error?.message}');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final task = ParseObject('masterTasks')..objectId = taskId;

    final ParseResponse response = await task.delete();

    if (response.success) {
      _tasks.removeWhere((task) => task.objectId == taskId);
      notifyListeners();
    } else {
      print('Error deleting task: ${response.error?.message}');
    }
  }
}
