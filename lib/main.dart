import 'package:flutter/material.dart';
import 'screens/home/home_screens.dart';

void main()  {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomeScreens(),
    );
  }
}
