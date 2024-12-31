import 'package:ajit_task_managment_zybra_task/Providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:ajit_task_managment_zybra_task/models/task.dart';
import 'package:ajit_task_managment_zybra_task/Screens/TaskDetailsScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListView extends ConsumerWidget {
  final List<Task> tasks;
  TaskListView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider); // Watch the task list
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Text(
            task.isCompleted ? 'Completed' : 'Pending',
            style: TextStyle(
              color: task.isCompleted ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            // Handle task tap if needed, such as navigating to task details or editing
           // _showTaskOptionsDialog(context, ref, task);
          },

        );
      },
    );
  }
}
void _showTaskOptionsDialog(BuildContext context, WidgetRef ref, Task task) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Choose an action'),
        content: Text('Do you want to edit or delete this task?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Navigate to edit task screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(task: task),
                ),
              );
            },
            child: Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Delete the task
              ref.read(taskProvider.notifier).deleteTask(task.id!);
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}