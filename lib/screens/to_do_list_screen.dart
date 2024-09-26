import 'package:flutter/material.dart';
import 'package:myapp/widgets/drawer_widget.dart';
import 'add_task_screen.dart';
import '../models/task_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    // _loadTasks();
  }

  // _loadTasks() async {
  //   // Simulation du chargement des tâches depuis une source persistante
  //   // SharedPreferences ou une base de données peuvent être utilisés pour sauvegarder les tâches
  // }

  _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted; // Inverser l'état
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Liste des tâches'),
      ),
      drawer: const DrawerWidget(),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted, 
                onChanged: (value) {
                  _toggleTaskCompletion(index); 
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              subtitle: Text(
                'Début: ${task.startDate.toLocal().toString().split(' ')[0]} - Fin: ${task.endDate.toLocal().toString().split(' ')[0]}',
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
