import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  String _recurrence = "Weekly";
  String? _editingTaskId;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  void _clearForm() {
    _titleController.clear();
    _recurrence = "Weekly";
    _editingTaskId = null;
    setState(() {});
  }

  void _submitForm(TaskProvider provider) {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    if (_editingTaskId != null) {
      provider.updateTask(_editingTaskId!, title, _recurrence);
    } else {
      provider.addTask(title, _recurrence);
    }

    _clearForm();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Tasks")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            /// ---- Add/Edit Task Form ----
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _recurrence,
              items: ["Weekly", "Monthly", "Yearly"]
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _recurrence = value!),
              decoration: InputDecoration(labelText: "Repeat"),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _submitForm(taskProvider),
                  child: Text(_editingTaskId != null ? "Update Task" : "Add Task"),
                ),
                if (_editingTaskId != null)
                  TextButton(
                    onPressed: _clearForm,
                    child: Text("Cancel"),
                  ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recurring'); 
                  },
                  child: Text("Read Mode"),
    ),
              ],
            ),
            Divider(height: 30),

            /// ---- Task List ----
            Expanded(
              child: taskProvider.tasks.isEmpty
                  ? Center(child: Text("No tasks available."))
                  : ListView.builder(
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.tasks[index];
                        final title = task.get<String>('taskTitle') ?? '';
                        final recurrence = task.get<String>('taskType') ?? '';

                        return ListTile(
                          title: Text(title),
                          subtitle: Text("Repeats: $recurrence"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _titleController.text = title;
                                  _recurrence = recurrence;
                                  _editingTaskId = task.objectId;
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => taskProvider.deleteTask(task.objectId!),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
