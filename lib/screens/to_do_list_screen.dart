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

  _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
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

          return Dismissible(
            key: Key(task.title), 
            direction: DismissDirection.endToStart, 
            onDismissed: (direction) {
              _deleteTask(index); 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${task.title} supprimée'),
                ),
              );
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
                                'à ${TimeOfDay.fromDateTime(task.startDate).format(context)}',
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
                                onPressed: () => _toggleTaskCompletion(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.photo),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.attach_file),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.location_on),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.mic),
                                onPressed: () {},
                              ),
                            ],
                          )
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
