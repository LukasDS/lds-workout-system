import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workout/app.dart';
import 'package:workout/core/storage/storage.dart';
import 'package:workout/core/storage/shared_prefs_storage.dart';
import 'package:workout/features/workout/data/workout_repository.dart';

class MockStorage extends Mock implements Storage {}
class MockWorkoutRepository extends Mock implements WorkoutRepository {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  testWidgets('HomeScreen infinite carousel works', (tester) async {
    // Set a larger surface size to ensure bottom navigation is on screen
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockPrefs = MockSharedPreferences();
    SharedPrefsStorage(mockPrefs);
    when(() => mockPrefs.getInt('currentIndex')).thenReturn(0);
    when(() => mockPrefs.setInt('currentIndex', any())).thenAnswer((_) async => true);

    final mockWorkoutRepository = MockWorkoutRepository();
    when(() => mockWorkoutRepository.watchCurrentWeight(any()))
        .thenAnswer((_) => Stream.value(null));

    await tester.pumpWidget(
      WorkoutApp(
        prefs: mockPrefs,
        initialIndex: 0,
        workoutRepository: mockWorkoutRepository,
      ),
    );

    await tester.pumpAndSettle();

    // Verify first page is visible
    expect(find.text('Quads and Abs'), findsWidgets);

    // 1. Test Navigation Bar: Tap 'Shoulders' (index 3)
    await tester.tap(find.text('Shoulders'));
    await tester.pumpAndSettle();
    expect(find.text('Shoulders and Arms'), findsWidgets);
    // storage is debounced, so we wait or trigger it
    await tester.pump(const Duration(milliseconds: 501));
    verify(() => mockPrefs.setInt('currentIndex', 3)).called(1);

    // 2. Test Swiping: Swipe right to go to 'Legs' (index 2)
    // Offset > 0 means swiping from left-to-right, moving viewport left.
    clearInteractions(mockPrefs);
    await tester.drag(find.byType(PageView), const Offset(600.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text('Legs'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 501));
    verify(() => mockPrefs.setInt('currentIndex', 2)).called(1);

    // 3. Test Navigation Bar: Tap 'Quads' (index 0)
    await tester.tap(find.text('Quads'));
    await tester.pumpAndSettle();
    expect(find.text('Quads and Abs'), findsWidgets);
    
    // 4. Test Infinite Loop: SWIPE RIGHT at the start to loop to the END
    clearInteractions(mockPrefs);
    await tester.drag(find.byType(PageView), const Offset(600.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text('Shoulders and Arms'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 501));
    verify(() => mockPrefs.setInt('currentIndex', 3)).called(1);
    
    // 5. Test Infinite Loop: SWIPE LEFT at the end to loop to the START
    clearInteractions(mockPrefs);
    await tester.drag(find.byType(PageView), const Offset(-600.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text('Quads and Abs'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 501));
    verify(() => mockPrefs.setInt('currentIndex', 0)).called(1);
  });

  testWidgets('HomeScreen loads with correct initial index', (tester) async {
    final mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getInt('currentIndex')).thenReturn(2);
    when(() => mockPrefs.setInt('currentIndex', any())).thenAnswer((_) async => true);

    final mockWorkoutRepository = MockWorkoutRepository();
    when(() => mockWorkoutRepository.watchCurrentWeight(any()))
        .thenAnswer((_) => Stream.value(null));

    await tester.pumpWidget(
      WorkoutApp(
        prefs: mockPrefs,
        initialIndex: 2,
        workoutRepository: mockWorkoutRepository,
      ),
    );

    await tester.pumpAndSettle();

    // Verify "Legs" split (index 2) is visible initially
    expect(find.text('Legs'), findsWidgets);
  });
}
