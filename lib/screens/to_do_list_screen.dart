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
  }

  _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
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
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Afficher une photo si elle est ajoutée, sinon un avatar par défaut
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
                            color: task.isCompleted ? Colors.grey : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Date et heure de début de la tâche avec une icône d'alarme
                        Row(
                          children: [
                            const Icon(
                              Icons.alarm,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Début: ${task.startDate.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'à ${TimeOfDay.fromDateTime(task.startDate).format(context)}', // Affichage de l'heure
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        
                        Text(
                          'Fin: ${task.endDate.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 5),
                        // Description de la tâche (si nécessaire)
                        if (task.description.isNotEmpty)
                          Text(
                            task.description,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        const SizedBox(height: 10),
                        // Ligne des icônes pour les actions
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
                              onPressed: () => _toggleTaskCompletion(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.photo),
                              onPressed: () {
                                // Action pour la photo
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: () {
                                // Action pour le fichier
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.location_on),
                              onPressed: () {
                                // Action pour la localisation
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.mic),
                              onPressed: () {
                                // Action pour l'audio
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
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
