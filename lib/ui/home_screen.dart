import 'package:flutter/material.dart';
import 'package:todolist/ui/todo_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ToDoScreen(),
    );
  }
}