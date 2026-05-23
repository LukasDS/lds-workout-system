import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workout/app.dart';
import 'package:workout/firebase_options.dart';
import 'package:workout/features/workout/data/firebase_workout_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firestore and Repository early to hide jank behind splash screen
  final firestore = FirebaseFirestore.instance;
  final workoutRepository = FirebaseWorkoutRepository(firestore);
  
  final prefs = await SharedPreferences.getInstance();
  final initialIndex = prefs.getInt('currentIndex') ?? 0;
  
  runApp(WorkoutApp(
    prefs: prefs,
    initialIndex: initialIndex,
    workoutRepository: workoutRepository,
  ));
}

