import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/recurring_task.dart'; 

// Recurring Task Provider for recurring task view mode filter screen
class RecurringTaskProvider with ChangeNotifier {
  List<MasterTask> masterTasks = [];
  bool isLoading = false;

  Future<void> fetchMasterTasks() async {
  isLoading = true;
  notifyListeners();

  final query = QueryBuilder<ParseObject>(ParseObject('masterTasks'));
  final response = await query.query();

  if (response.success && response.results != null) {
    masterTasks = response.results!.map((obj) => MasterTask.fromParse(obj)).toList();
  }
  
  isLoading = false;
  notifyListeners();
}
}
