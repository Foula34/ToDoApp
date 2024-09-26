class Task {
  String title;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted; // Déclaration de la propriété isCompleted

  Task({
    required this.title,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false, required String description, // Initialisation par défaut
  });
}
