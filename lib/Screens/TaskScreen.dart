import 'package:ajit_task_managment_zybra_task/Screens/TaskDetailsScreen.dart';
import 'package:ajit_task_managment_zybra_task/Screens/TaskDetailsView.dart';
import 'package:ajit_task_managment_zybra_task/utils/responsive_layout.dart';
import 'package:ajit_task_managment_zybra_task/widgets/task_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ajit_task_managment_zybra_task/providers/task_provider.dart';
import 'package:ajit_task_managment_zybra_task/models/task.dart';

class TaskScreen extends ConsumerWidget {
  String _filterStatus = "All"; // Default filter status
  final List<String> _statuses = ["All", "Complete", "Pending"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///  final tasks = ref.watch(taskProvider); // Watch the task list
    final tasks = ref.watch(taskProvider)
      ..sort((a, b) {
        if (a.dueDate == null) return 1; // Tasks without a due date go last
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!); // Ascending order
      });
    // Filter tasks based on the selected status
    final filteredTasks = _filterStatus == "All"
        ? tasks
        : tasks
            .where((task) => task.isCompleted == (_filterStatus == "Complete"))
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Task Management')),
      body: tasks.isEmpty
          ? Center(
              child: Text('No tasks available')) // Show message if no tasks
          : Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      // Add spacing between items
                      padding: EdgeInsets.all(12.0),
                      // Add padding inside the container
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1.0, // Border width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4.0, // Shadow blur
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text("Title: " + task.title),
                        subtitle: Text("description: " +
                            task.description +
                            "\n " +
                            ' Date${_formatDateTime(task.dueDate!)}'),
                        trailing: Text(
                          task.isCompleted ? 'Completed' : 'Pending',
                          style: TextStyle(
                            color:
                                task.isCompleted ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Handle task tap if needed (like viewing/editing the task)
                          _showTaskOptionsDialog(context, ref, task);
                        },
                        onLongPress: () {
                          // Show a dialog to either Edit or Delete the task
                        },
                      ));
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Navigate to the TaskDetailsScreen to input task details
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (context) => TaskDetailsScreen()),
          );

          // If the user has entered a task, add it to the list
          if (newTask != null) {
            ref.read(taskProvider.notifier).addTask(newTask);
          }
        },
      ),
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
              // Navigate to view task details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsView(task: task),
                ),
              );
            },
            child: Text('View Details'),
          ),
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
String _formatDateTime(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}