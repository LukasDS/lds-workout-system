import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workout/models/exercise_info.dart';
import 'package:workout/widgets/workout_split.dart';

void main() {
  setUpAll(() => registerFallbackValue(DateTime.now()));

  testWidgets('WorkoutSplit shows title and exercises', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WorkoutSplit(
        title: 'Legs',
        exercises: [
          ExerciseInfo(
            name: 'Deadlifts',
            warmupInfo: (w) => '', 
          ),
          ExerciseInfo(
            name: 'Calf raises',
            warmupInfo: (w) => ''
          )
        ]
      )
    ));
    expect(find.text('Legs'), findsOneWidget);
    expect(find.text('Deadlifts'), findsOneWidget);
    expect(find.text('Calf raises'), findsOneWidget);
  });
}