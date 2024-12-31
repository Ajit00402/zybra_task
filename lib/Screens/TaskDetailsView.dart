import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ajit_task_managment_zybra_task/models/task.dart';
import 'package:ajit_task_managment_zybra_task/providers/task_provider.dart';

class TaskDetailsView extends ConsumerWidget {
  final Task task;

  TaskDetailsView({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Delete the task
              ref.read(taskProvider.notifier).deleteTask(task.id!);
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${task.title}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              'Description: ${task.description}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              'Status: ${task.isCompleted ? "Completed" : "Pending"}',
              style: TextStyle(
                color: task.isCompleted ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Created At: ${task.createdAt.toLocal()}',
            ),
            SizedBox(height: 24.0),
            /*ElevatedButton(
              onPressed: () {
                // Navigate to edit screen (optional)
                _showEditDialog(context, ref, task);
              },
              child: Text('Edit Task'),
            ),*/
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField<bool>(
              value: task.isCompleted,
              items: [
                DropdownMenuItem(
                  value: false,
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {
                task.isCompleted = value ?? false;
              },
              decoration: InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update task
             /* ref.read(taskProvider.notifier).editTask(
                task.id!,
                titleController.text,
                descriptionController.text,

              );*/
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Go back to the list view
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
