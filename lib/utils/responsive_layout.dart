import 'package:ajit_task_managment_zybra_task/Screens/TaskDetailsView.dart';
import 'package:ajit_task_managment_zybra_task/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ajit_task_managment_zybra_task/providers/task_provider.dart';
import 'package:ajit_task_managment_zybra_task/Screens/TaskDetailsScreen.dart';

class TaskScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider); // Watching tasks list

    return Scaffold(
      appBar: AppBar(title: Text('Task Management')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet or larger devices: Show task list and details side by side
            return Row(
              children: [
                Expanded(
                  child: TaskListView(tasks: tasks),
                ),
                /*Expanded(
                  child: TaskDetailsView(task: task),
                ),*/
              ],
            );
          } else {
            // Mobile devices: Show only task list
            return TaskListView(tasks: tasks);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskDetailsScreen()),
          );
        },
      ),
    );
  }
}

class TaskListView extends ConsumerWidget {
  final List<Task> tasks;
  TaskListView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text("Title: "+task.title),
          subtitle: Text("description: "+task.description),

          trailing: Text(
            task.isCompleted ? 'Completed' : 'Pending',
            style: TextStyle(
              color: task.isCompleted ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            _showTaskOptionsDialog(context, ref, task);
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
/*
class TaskDetailsView extends StatelessWidget {
  final List<Task> tasks;
  TaskDetailsView({required this.tasks});

  @override
  Widget build(BuildContext context) {
    // You can display detailed task view or empty space if no task is selected
    return tasks.isEmpty
        ? Center(child: Text("Select a task to view details"))
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Details',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          // Display task details here, for example:
          // You can get selected task from state or pass the task directly as argument
          Text('Title: ${tasks.first.title}'),
          Text('Description: ${tasks.first.description}'),
          Text('Created At: ${tasks.first.createdAt}'),
        ],
      ),
    );
  }
}
*/
