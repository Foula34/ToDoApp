import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _taskTitle = '';
  String _taskDescription = '';
  DateTime? _startDate;
  DateTime? _endDate;

  // Méthode pour sélectionner les dates
  _selectDate(BuildContext context, bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  
  _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_startDate != null && _endDate != null) {
        Task newTask = Task(
          title: _taskTitle,
          description: _taskDescription,
          startDate: _startDate!,
          endDate: _endDate!,
        );
        Navigator.pop(context, newTask);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner les dates.')),
        );
      }
    }
  }

  // Gestion des actions des icônes (à implémenter avec les packages correspondants)
  void _takePhoto() {
    // Action pour ouvrir la caméra
  }

  void _pickFile() {
    // Action pour sélectionner un fichier
  }

  void _addLocation() {
    // Action pour ajouter une localisation
  }

  void _recordAudio() {
    // Action pour enregistrer un fichier audio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une Tâche'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Champs pour le titre de la tâche
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Titre de la tâche'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _taskTitle = value!;
                  },
                ),

                // Champs pour la description de la tâche
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _taskDescription = value!;
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _takePhoto,
                      tooltip: 'Prendre une photo',
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _pickFile,
                      tooltip: 'Joindre un fichier',
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: _addLocation,
                      tooltip: 'Ajouter une localisation',
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: _recordAudio,
                      tooltip: 'Enregistrer un audio',
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_startDate == null
                        ? 'Début: Choisir une date'
                        : 'Début: ${_startDate!.toLocal().toString().split(' ')[0]}'),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, true),
                      child: const Text('Sélectionner début'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_endDate == null
                        ? 'Fin: Choisir une date'
                        : 'Fin: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, false),
                      child: const Text('Sélectionner fin'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _submitTask,
                  child: const Text('Ajouter Tâche'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
