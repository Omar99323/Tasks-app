import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do/helpers/bloc_observer.dart';
import 'screens/home/home_screens.dart';

void main()  {
  Bloc.observer = MyBlocObserver();
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
