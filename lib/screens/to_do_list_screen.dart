import 'package:flutter/material.dart';
import '/models/task_model.dart';
import '/models/task_service.dart';
import 'add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Charger les tâches lors de l'initialisation
  }

  // Charger les tâches depuis Shared Preferences
  Future<void> _loadTasks() async {
    List<Task> tasks = await _taskService.loadTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  // Ajouter une nouvelle tâche et la sauvegarder
  Future<void> _addTask(Task task) async {
    setState(() {
      _tasks.add(task);
    });
    await _taskService.saveTasks(_tasks); // Sauvegarder la liste mise à jour
  }

  // Supprimer une tâche et mettre à jour la sauvegarde
  Future<void> _deleteTask(int index) async {
    setState(() {
      _tasks.removeAt(index);
    });
    await _taskService.saveTasks(_tasks); // Sauvegarder la liste mise à jour
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des tâches'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('Aucune tâche pour le moment.'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return Dismissible(
                  key: Key(task.title),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteTask(index);  // Supprimer la tâche
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: task.image != null
                                ? FileImage(task.image!)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted ? Colors.grey : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.alarm,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Début: ${task.startDate.toLocal().toString().split(' ')[0]}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'à ${TimeOfDay.fromDateTime(task.startDate).format(context)}', // Affichage de l'heure
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Fin: ${task.endDate.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 5),
                                if (task.description.isNotEmpty)
                                  Text(
                                    task.description,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        task.isCompleted
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: task.isCompleted ? Colors.green : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          task.isCompleted = !task.isCompleted;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.photo),
                                      onPressed: () {
                                        // Ajoute ici la logique pour gérer les photos
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.attach_file),
                                      onPressed: () {
                                        // Ajoute ici la logique pour gérer les fichiers
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.location_on),
                                      onPressed: () {
                                        // Ajoute ici la logique pour gérer la localisation
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.mic),
                                      onPressed: () {
                                        // Ajoute ici la logique pour gérer l'audio
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );

          if (newTask != null) {
            _addTask(newTask);  // Ajouter une nouvelle tâche
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
