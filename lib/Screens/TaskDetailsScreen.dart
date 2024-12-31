import 'package:flutter/material.dart';
import 'package:ajit_task_managment_zybra_task/models/task.dart';
import 'package:ajit_task_managment_zybra_task/providers/task_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  final Task? task; // task can be null for new task addition

  TaskDetailsScreen({this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _status;
  DateTime? _selectedDueDate; // Selected due date

  // List of status options for dropdown
  final List<String> _statusOptions = ['Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current task's data, if available
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _status = widget.task?.isCompleted == true
        ? 'Completed'
        : 'Pending'; // Set default status
    //_selectedDueDate = widget.task!.dueDate;
  }

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            // DropdownButton for task completion status
            DropdownButton<String>(
              value: _status,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: _statusOptions.map<DropdownMenuItem<String>>((
                  String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ListTile(
              title: Text(
                _selectedDueDate != null
                    ? 'Due Date: ${_formatDateTime(_selectedDueDate!)}'
                    : 'Select Due Date',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDueDate, // Open date picker
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                /*if (widget.task == null) {
                  // Add new task
                  ref.read(taskProvider.notifier).addTask(*/
                if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty&& _selectedDueDate!=null) {
                  final newTask = Task(
                    id: DateTime
                        .now()
                        .millisecondsSinceEpoch,
                    // Generate a unique ID for the new task
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isCompleted: _status == 'Completed',
                    // Convert string to boolean
                    createdAt: DateTime.now(),
                    dueDate: _selectedDueDate,

                  );
                  if (widget.task == null) {
                    // Add new task
                    ref.read(taskProvider.notifier).addTask(newTask);
                  } else {
                    // Edit existing task
                    ref.read(taskProvider.notifier).editTask(
                      widget.task!.id!,
                      _titleController.text,
                      _descriptionController.text,
                      _status == 'Completed', // Convert string to boolean
                      newTask.dueDate,

                    );
                  }
                  Navigator.pop(context); // Go back to the previous screen
                }else{
                  Fluttertoast.showToast(
                    msg: "Enter all deatils",
                    toastLength: Toast.LENGTH_SHORT, // Toast.LENGTH_SHORT or Toast.LENGTH_LONG
                    gravity: ToastGravity.BOTTOM,   // ToastGravity.TOP, ToastGravity.CENTER, or ToastGravity.BOTTOM
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }},
              child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
String _formatDateTime(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}
