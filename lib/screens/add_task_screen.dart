import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import du package Geolocator
import '../models/task_model.dart';
import '../widgets/image_picker_service.dart'; // Import du service ImagePicker

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
  TimeOfDay? _startTime;
  File? _selectedImage; // Stockage de l'image sélectionnée
  String? _location; // Stockage de la localisation sélectionnée

  final ImagePickerService _imagePickerService = ImagePickerService(); // Instance du service d'image

  // Méthode pour sélectionner une image à partir de la galerie
  Future<void> _pickImageFromGallery() async {
    File? image = await _imagePickerService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // Méthode pour prendre une photo avec la caméra
  Future<void> _takePhoto() async {
    File? photo = await _imagePickerService.takePhoto();
    if (photo != null) {
      setState(() {
        _selectedImage = photo;
      });
    }
  }

  // Méthode pour récupérer la localisation
  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service de localisation désactivé.')),
      );
      return;
    }

    // Demande la permission d'accéder à la localisation
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission refusée')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Permission de localisation refusée de manière permanente.')),
      );
      return;
    }

    // Récupère la position actuelle
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = '${position.latitude}, ${position.longitude}';
    });
  }

  // Méthode pour sélectionner la date
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

  // Méthode pour sélectionner l'heure
  _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_startDate != null && _endDate != null && _startTime != null) {
        // Créer une nouvelle tâche avec les données saisies
        Task newTask = Task(
          title: _taskTitle,
          description: _taskDescription,
          startDate: DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
            _startTime!.hour,
            _startTime!.minute,
          ),
          endDate: _endDate!,
          image: _selectedImage, // Ajouter l'image à la tâche
          location: _location, // Ajouter la localisation à la tâche
        );
        Navigator.pop(context, newTask);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Veuillez sélectionner les dates, heures et localisation.')),
        );
      }
    }
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
                  decoration: const InputDecoration(labelText: 'Titre de la tâche'),
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

                // Affichage de l'image sélectionnée
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),

                // Icônes pour ajouter une image ou prendre une photo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _takePhoto,
                      tooltip: 'Prendre une photo',
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_library),
                      onPressed: _pickImageFromGallery,
                      tooltip: 'Sélectionner une image',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sélection de la localisation avec une icône
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(_location == null
                        ? 'Localisation: Non définie'
                        : 'Localisation: $_location'),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: _getLocation,
                      tooltip: 'Sélectionner localisation',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sélection de la date et de l'heure
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_startDate == null
                        ? 'Début: Choisir une date'
                        : 'Début: ${_startDate!.toLocal().toString().split(' ')[0]}'),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, true),
                      child: const Text('Sélectionner date'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_endDate == null
                        ? 'Fin: Choisir une date'
                        : 'Fin: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, false),
                      child: const Text('Sélectionner date'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_startTime == null
                        ? 'Heure de début: Choisir une heure'
                        : 'Heure: ${_startTime!.format(context)}'),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: const Text('Sélectionner heure'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Bouton pour ajouter la tâche
                ElevatedButton(
                  onPressed: _submitTask,
                  child: const Text('Ajouter la tâche'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
