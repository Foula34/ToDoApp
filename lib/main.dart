import 'package:flutter/material.dart';
import 'screens/to_do_list_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App ',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      
      home:  TodoListScreen(),
    );
  }
}
