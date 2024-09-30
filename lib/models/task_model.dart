import 'dart:convert';
import 'dart:io';

class Task {
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  File? image; 
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.image,
    this.isCompleted = false,
  });

  // Convertir la tâche en un format JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'image': image?.path, // Sauvegarde du chemin de l'image
      'isCompleted': isCompleted,
    };
  }

  // Créer une tâche à partir d'un format JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      image: json['image'] != null ? File(json['image']) : null, // Chargement de l'image
      isCompleted: json['isCompleted'],
    );
  }
}
