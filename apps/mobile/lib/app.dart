import 'package:flutter/material.dart';
import 'screens/workout_home.dart';

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 181, 0, 30),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 181, 0, 30),
          onSecondary: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.black,
        )
      ),
      debugShowCheckedModeBanner: false,
      home: const WorkoutHome(),
    );
  }
}