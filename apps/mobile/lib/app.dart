import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/repositories/firebase_workout_repository.dart';
import 'package:workout/repositories/workout_repository.dart';
import 'package:workout/storage/local_storage.dart';
import 'package:workout/storage/shared_prefs_storage.dart';
import 'screens/workout_home.dart';

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorage>(create: (_) => SharedPrefsStorage()),
        Provider<WorkoutRepository>(create: (_) => FirebaseWorkoutRepository(FirebaseFirestore.instance))
      ],
      child: MaterialApp(
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
        )
    );  
  }
}