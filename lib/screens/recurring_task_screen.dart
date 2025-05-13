import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recurring_task_provider.dart';

class RecurringTaskScreen extends StatefulWidget {
  @override
  _RecurringTaskScreenState createState() => _RecurringTaskScreenState();
}

class _RecurringTaskScreenState extends State<RecurringTaskScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RecurringTaskProvider>(context, listen: false);
    provider.fetchMasterTasks(); 
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecurringTaskProvider>(context);
    final allTasks = provider.masterTasks;

    // Filter tasks
    final filteredTasks = _selectedFilter == 'All'
        ? allTasks
        : allTasks.where((task) => task.recurrence == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Master Tasks View"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: ['All', 'Weekly', 'Monthly', 'Yearly']
                  .map((filter) => DropdownMenuItem(
                        value: filter,
                        child: Text(filter),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
              },
              isExpanded: true,
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredTasks.isEmpty
                    ? Center(child: Text("No tasks found."))
                    : ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              title: Text(task.title),
                              subtitle: Text("Repeats: ${task.recurrence}"),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
