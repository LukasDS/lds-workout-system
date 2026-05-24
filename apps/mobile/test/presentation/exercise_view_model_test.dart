import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/features/workout/presentation/exercise_view_model.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

void main() {
  late MockWorkoutRepository mockRepository;
  late StreamController<double?> streamController;

  setUp(() {
    mockRepository = MockWorkoutRepository();
    streamController = StreamController<double?>();
    
    when(() => mockRepository.watchCurrentWeight(any()))
        .thenAnswer((_) => streamController.stream);
    when(() => mockRepository.setCurrentWeight(any(), any()))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    streamController.close();
  });

  group('ExerciseViewModel', () {
    test('initializes with loading state and subscribes to stream', () async {
      final viewModel = ExerciseViewModel(
        repository: mockRepository,
        exerciseName: 'Bench Press',
      );

      expect(viewModel.isLoading, true);
      expect(viewModel.weight, null);

      streamController.add(100.0);
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, false);
      expect(viewModel.weight, 100.0);
      
      viewModel.dispose();
    });

    test('updateWeight updates state and debounces save', () async {
      final viewModel = ExerciseViewModel(
        repository: mockRepository,
        exerciseName: 'Bench Press',
      );

      viewModel.updateWeight(120.0);
      expect(viewModel.weight, 120.0);
      
      // Repository should not be called immediately (1s debounce)
      verifyNever(() => mockRepository.setCurrentWeight(any(), any()));

      // Wait for debounce
      await Future.delayed(const Duration(milliseconds: 1100));
      
      verify(() => mockRepository.setCurrentWeight('Bench Press', 120.0)).called(1);
      
      viewModel.dispose();
    });

    test('handles stream error', () async {
      final viewModel = ExerciseViewModel(
        repository: mockRepository,
        exerciseName: 'Bench Press',
      );

      streamController.addError('Error');
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, 'Failed to load weight.');
      
      viewModel.dispose();
    });

    test('handles save error', () async {
      when(() => mockRepository.setCurrentWeight(any(), any()))
          .thenThrow(Exception('Save failed'));

      final viewModel = ExerciseViewModel(
        repository: mockRepository,
        exerciseName: 'Bench Press',
      );

      viewModel.updateWeight(150.0);
      
      // Wait for debounce
      await Future.delayed(const Duration(milliseconds: 1100));
      
      expect(viewModel.errorMessage, 'Failed to save weight.');
      
      viewModel.dispose();
    });
  });
}
