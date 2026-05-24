import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final initialIndex = prefs.getInt('currentIndex') ?? 0;
  
  runApp(WorkoutApp(
    prefs: prefs,
    initialIndex: initialIndex,
  ));
}

