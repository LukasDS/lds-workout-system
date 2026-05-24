import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/app.dart';
import 'package:workout/features/workout/data/workout_repository.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockWorkoutRepository extends Mock implements WorkoutRepository {}

void main() {
  late MockSharedPreferences mockPrefs;
  late MockWorkoutRepository mockRepository;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockRepository = MockWorkoutRepository();

    when(() => mockPrefs.getInt('currentIndex')).thenReturn(0);
    when(() => mockRepository.watchCurrentWeight(any()))
        .thenAnswer((_) => Stream.value(null));
  });

  testWidgets('WorkoutApp renders correctly with provided dependencies', (tester) async {
    await tester.pumpWidget(
      WorkoutApp(
        prefs: mockPrefs,
        initialIndex: 0,
        workoutRepository: mockRepository,
      ),
    );

    await tester.pumpAndSettle();

    // Verify it renders the WorkoutScreen which should show the first split title
    expect(find.text('Quads and Abs'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
