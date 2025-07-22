import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout/models/exercise_info.dart';
import 'package:workout/widgets/exercise.dart';

void main() {
  // A dummy warmup callback for testing
  String dummyWarmup(double? w) => w == null ? '' : 'Warmup for $w';

  testWidgets('Renders exercise name and empty input', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Exercise(
        exerciseInfo: ExerciseInfo(
          name: 'Pushups',
          warmupInfo: dummyWarmup
        ),
      )
    ));

    expect(find.text('Pushups'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Warmup for'), findsNothing);
  });

  testWidgets('Updates warmup when weight entered', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Exercise(
        exerciseInfo: ExerciseInfo(
          name: 'Squats',
          warmupInfo: dummyWarmup
        ),
      )
    ));

    await tester.enterText(find.byType(TextField), '42');
    expect(find.text('Warmup for 42'), findsOneWidget);
  });
}