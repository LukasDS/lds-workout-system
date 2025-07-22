import 'package:flutter/material.dart';
import 'package:workout/models/exercise_info.dart';
import 'package:workout/widgets/exercise.dart';

/// A widget representing a workout split, containing multiple exercises.
/// It displays a title and a list of exercises, each with optional special warmup information.
///
class WorkoutSplit extends StatelessWidget {
  final String title;
  final List<ExerciseInfo> exercises;

  const WorkoutSplit({
    super.key,
    required this.title,
    required this.exercises
  });

  /// Builds the widget tree for the WorkoutSplit.
  /// This method creates a Scaffold with an AppBar and a body containing a list of Exercise widgets.
  ///
  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: List.generate(
            exercises.length,
            (index) => Exercise(
              exerciseInfo: exercises[index]
            ),
          ),
        ),
      ),
    );
  }
}