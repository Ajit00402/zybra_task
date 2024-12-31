import 'package:ajit_task_managment_zybra_task/models/task.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ajit_task_managment_zybra_task/services/task_database_helper.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  // Add a new task
  void addTask(Task task) {
    state = [...state, task];
    TaskDatabaseHelper().insertTask(task);
  }

  // Edit a task
  void editTask(int id, String newTitle, String newDescription, bool isCompleted,DateTime ?_selectedDueDate) {
    state = state.map((task) {
      if (task.id == id) {
        return Task(
          id: task.id,
          title: newTitle,
          description: newDescription,
          isCompleted: isCompleted,
          createdAt: DateTime.now(),
          dueDate: _selectedDueDate,
        );
      }
      return task;
    }).toList();
    TaskDatabaseHelper().updateTask(state.firstWhere((task) => task.id == id));
  }

  // Delete a task
  void deleteTask(int id) {
    state = state.where((task) => task.id != id).toList();
    TaskDatabaseHelper().deleteTask(id);
  }

  // Toggle task completion
  void toggleTaskCompletion(int id) {
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    TaskDatabaseHelper().updateTask(state.firstWhere((task) => task.id == id));
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
