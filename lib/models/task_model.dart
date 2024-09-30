import 'dart:io';

class Task {
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  File? image;
  bool isCompleted;
  double? latitude;  
  double? longitude; 

  Task({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.image,
    this.isCompleted = false,
    this.latitude,
    this.longitude, String? location,
  });
}
