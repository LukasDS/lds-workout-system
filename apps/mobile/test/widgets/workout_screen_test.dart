import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:workout/core/storage/local_storage.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/features/workout/presentation/workout_screen.dart';

class MockLocalStorage extends Mock implements LocalStorage {}
class MockWorkoutRepository extends Mock implements WorkoutRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  testWidgets('WorkoutScreen infinite carousel works', (tester) async {
    final mockLocalStorage = MockLocalStorage();
    when(() => mockLocalStorage.getInt('currentIndex')).thenAnswer((_) async => 0);
    when(() => mockLocalStorage.setInt('currentIndex', any())).thenAnswer((_) async {});

    // Need a real-ish or better mocked repository for ExerciseWidget inside the splits
    // but here we just need to satisfy the provider.
    final mockWorkoutRepository = MockWorkoutRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LocalStorage>.value(value: mockLocalStorage),
          Provider<WorkoutRepository>.value(value: mockWorkoutRepository),
        ],
        child: const MaterialApp(
          home: WorkoutScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify first page is visible
    expect(find.text('Quads and Abs'), findsWidgets);

    // 1. Test Navigation Bar: Tap 'Shoulders' (index 3)
    await tester.tap(find.text('Shoulders'));
    await tester.pumpAndSettle();
    expect(find.text('Shoulders and Arms'), findsWidgets);
    verify(() => mockLocalStorage.setInt('currentIndex', 3)).called(1);

    // 2. Test Swiping: Swipe right to go to 'Legs' (index 2)
    // Offset > 0 means swiping from left-to-right, moving viewport left.
    await tester.drag(find.byType(PageView), const Offset(600.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text('Legs'), findsWidgets);
    verify(() => mockLocalStorage.setInt('currentIndex', 2)).called(1);

    // 3. Test Navigation Bar: Tap 'Quads' (index 0)
    await tester.tap(find.text('Quads'));
    await tester.pumpAndSettle();
    expect(find.text('Quads and Abs'), findsWidgets);
    
    // 4. Test Infinite Loop: SWIPE RIGHT at the start to loop to the END
    await tester.drag(find.byType(PageView), const Offset(600.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text('Shoulders and Arms'), findsWidgets);
    verify(() => mockLocalStorage.setInt('currentIndex', 3)).called(1);
    
    // 5. Test Infinite Loop: SWIPE LEFT at the end to loop to the START
    await tester.drag(find.byType(PageView), const Offset(-600.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text('Quads and Abs'), findsWidgets);
    verify(() => mockLocalStorage.setInt('currentIndex', 0)).called(1);
  });
}
