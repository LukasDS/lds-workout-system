import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:workout/features/workout/domain/exercise_info.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/features/workout/presentation/exercise_widget.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

void main() {
  setUpAll(() => registerFallbackValue(DateTime.now()));

  // A dummy warmup callback for testing
  String dummyWarmup(double? w) => w == null ? '' : 'Warmup for $w';

  final mockRepository = MockWorkoutRepository();
    when(() => mockRepository.getCurrentWeight(any()))
        .thenAnswer((_) async => null);
    when(() => mockRepository.setCurrentWeight(any(), any()))
        .thenAnswer((_) async {});

  testWidgets('Renders exercise name and empty input', (tester) async {
    await tester.pumpWidget(
      Provider<WorkoutRepository>.value(
        value: mockRepository,
        child: MaterialApp(
          home: ExerciseWidget(
            exerciseInfo: ExerciseInfo(
              name: 'Pushups',
              warmupInfo: dummyWarmup
            ),
          )
        )
      )
    );

    expect(find.text('Pushups'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Warmup for'), findsNothing);
  });

  testWidgets('Updates warmup when weight entered', (tester) async {
    await tester.pumpWidget(
      Provider<WorkoutRepository>.value(
        value: mockRepository,
        child: MaterialApp(
          home: ExerciseWidget(
            exerciseInfo: ExerciseInfo(
              name: 'Squats',
              warmupInfo: dummyWarmup
            ),
          )
        )
      )
    );

    await tester.enterText(find.byType(TextField), '42');
    expect(find.text('Warmup for 42'), findsOneWidget);
  });
}