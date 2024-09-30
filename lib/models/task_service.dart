import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_model.dart';

class TaskService {
  static const String _tasksKey = 'tasks';

  // Sauvegarder les tâches dans Shared Preferences
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, taskList);
  }

  // Charger les tâches depuis Shared Preferences
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList(_tasksKey);

    if (taskList != null) {
      return taskList.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList();
    } else {
      return [];
    }
  }
}
