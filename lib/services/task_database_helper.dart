import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ajit_task_managment_zybra_task/models/task.dart';

class TaskDatabaseHelper {
  static final TaskDatabaseHelper _instance = TaskDatabaseHelper._internal();
  factory TaskDatabaseHelper() => _instance;

  TaskDatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'tasks.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isCompleted INTEGER,
            createdAt TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Insert a task into the database
  Future<void> insertTask(Task task) async {
    final db = await _getDatabase();
    await db.insert('tasks', task.toMap());
  }

  // Get all tasks from the database
  Future<List<Task>> getTasks() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Update a task in the database
  Future<void> updateTask(Task task) async {
    final db = await _getDatabase();
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task from the database
  Future<void> deleteTask(int id) async {
    final db = await _getDatabase();
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
