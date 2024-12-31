/*
import 'package:ajit_task_managment_zybra_task/Models/task.dart';
import 'package:riverpod/riverpod.dart';
//import 'task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void editTask(int id, String newTitle, String newDescription) {
    state = state.map((task) {
      if (task.id == id) {
        return Task(
          id: task.id,
          title: newTitle,
          description: newDescription,
          isCompleted: task.isCompleted, createdAt:  DateTime.now(),
        );
      }
      return task;
    }).toList();
  }

  void deleteTask(int id) {
    state = state.where((task) => task.id != id).toList();
  }

  void toggleTaskCompletion(int id) {
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
  }
}

// Define the provider
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
*/
