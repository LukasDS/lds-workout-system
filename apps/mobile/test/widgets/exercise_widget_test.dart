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
    when(() => mockRepository.watchCurrentWeight(any()))
        .thenAnswer((_) => Stream.value(null));
    when(() => mockRepository.setCurrentWeight(any(), any()))
        .thenAnswer((_) async {});

  testWidgets('Renders exercise name and empty input', (tester) async {
    await tester.pumpWidget(
      Provider<WorkoutRepository?>.value(
        value: mockRepository,
        child: MaterialApp(
          home: Scaffold(
            body: ExerciseWidget(
              exerciseInfo: ExerciseInfo(
                name: 'Pushups',
                warmupInfo: dummyWarmup
              ),
            ),
          )
        )
      )
    );

    await tester.pumpAndSettle();

    expect(find.text('Pushups'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Warmup for'), findsNothing);
  });

  testWidgets('Initial weight is loaded from repository', (tester) async {
    when(() => mockRepository.watchCurrentWeight('Bench Press'))
        .thenAnswer((_) => Stream.value(100.0));

    await tester.pumpWidget(
      Provider<WorkoutRepository?>.value(
        value: mockRepository,
        child: MaterialApp(
          home: Scaffold(
            body: ExerciseWidget(
              exerciseInfo: ExerciseInfo(
                name: 'Bench Press',
                warmupInfo: dummyWarmup
              ),
            ),
          )
        )
      )
    );

    await tester.pumpAndSettle();

    expect(find.text('100'), findsOneWidget);
    expect(find.text('Warmup for 100.0'), findsOneWidget);
  });

  testWidgets('Updates warmup and saves weight with debounce', (tester) async {
    when(() => mockRepository.watchCurrentWeight('Squats'))
        .thenAnswer((_) => Stream.value(null));

    await tester.pumpWidget(
      Provider<WorkoutRepository?>.value(
        value: mockRepository,
        child: MaterialApp(
          home: Scaffold(
            body: ExerciseWidget(
              exerciseInfo: ExerciseInfo(
                name: 'Squats',
                warmupInfo: dummyWarmup
              ),
            ),
          )
        )
      )
    );

    await tester.pumpAndSettle();
    
    // Enter text
    await tester.enterText(find.byType(TextField), '42');
    await tester.pump();
    
    // Warmup should update immediately
    expect(find.text('Warmup for 42.0'), findsOneWidget);
    
    // Repository should NOT be called yet (due to 1s debounce)
    verifyNever(() => mockRepository.setCurrentWeight('Squats', 42.0));
    
    // Wait for debouncer
    await tester.pump(const Duration(seconds: 2));
    
    // Now it should be called
    verify(() => mockRepository.setCurrentWeight('Squats', 42.0)).called(1);
  });

  testWidgets('Does not render weight input when requiresWeight is false', (tester) async {
    await tester.pumpWidget(
      Provider<WorkoutRepository?>.value(
        value: mockRepository,
        child: const MaterialApp(
          home: Scaffold(
            body: ExerciseWidget(
              exerciseInfo: ExerciseInfo(
                name: 'Hollow Body Hold',
                requiresWeight: false
              ),
            ),
          ),
        ),
      )
    );

    await tester.pumpAndSettle();
    expect(find.text('Hollow Body Hold'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('Shows SnackBar on stream error', (tester) async {
    when(() => mockRepository.watchCurrentWeight('Error Exercise'))
        .thenAnswer((_) => Stream.error('Stream failed'));

    await tester.pumpWidget(
      Provider<WorkoutRepository?>.value(
        value: mockRepository,
        child: MaterialApp(
          home: Scaffold(
            body: ExerciseWidget(
              exerciseInfo: ExerciseInfo(
                name: 'Error Exercise',
                warmupInfo: dummyWarmup
              ),
            ),
          )
        )
      )
    );

    await tester.pumpAndSettle();
    expect(find.text('Failed to load weight.'), findsOneWidget);
  });

  testWidgets('Shows SnackBar on save error', (tester) async {
    when(() => mockRepository.watchCurrentWeight('Save Error'))
        .thenAnswer((_) => Stream.value(null));
    when(() => mockRepository.setCurrentWeight('Save Error', any()))
        .thenThrow(Exception('Save failed'));

    await tester.pumpWidget(
      Provider<WorkoutRepository?>.value(
        value: mockRepository,
        child: MaterialApp(
          home: Scaffold(
            body: ExerciseWidget(
              exerciseInfo: ExerciseInfo(
                name: 'Save Error',
                warmupInfo: dummyWarmup
              ),
            ),
          )
        )
      )
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '10');
    
    // Wait for debounce
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(); // SnackBar needs another pump to show up

    expect(find.text('Failed to save weight.'), findsOneWidget);
  });

  testWidgets('Resubscribes when repository changes', (tester) async {
    final mockRepository2 = MockWorkoutRepository();
    when(() => mockRepository2.watchCurrentWeight(any()))
        .thenAnswer((_) => Stream.value(88.0));

    bool useFirst = true;

    // A wrapper to change the provider value
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return Provider<WorkoutRepository?>.value(
            value: useFirst ? mockRepository : mockRepository2,
            child: MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    const ExerciseWidget(
                      exerciseInfo: ExerciseInfo(name: 'Switch Test'),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => useFirst = false),
                      child: const Text('Switch'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpAndSettle();
    // Initially null (from mockRepository)
    expect(find.text('88'), findsNothing);

    await tester.tap(find.text('Switch'));
    await tester.pumpAndSettle();

    // Now it should show 88 from mockRepository2
    expect(find.text('88'), findsOneWidget);
  });
}