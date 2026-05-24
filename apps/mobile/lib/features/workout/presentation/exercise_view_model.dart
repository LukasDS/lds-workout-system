import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/core/utils/debouncer.dart';

/// A ViewModel for managing the state of an exercise, handling data streams and saving logic.
class ExerciseViewModel extends ChangeNotifier {
  final WorkoutRepository repository;
  final String exerciseName;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);

  double? _weight;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<double?>? _subscription;

  ExerciseViewModel({
    required this.repository,
    required this.exerciseName,
  }) {
    _subscribeToData();
  }

  double? get weight => _weight;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _subscribeToData() {
    _subscription?.cancel();
    _subscription = repository.watchCurrentWeight(exerciseName).listen(
      (weight) {
        _weight = weight;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('ExerciseViewModel Error: $e');
        _isLoading = false;
        _errorMessage = 'Failed to load weight.';
        notifyListeners();
      },
    );
  }

  /// Updates the local weight state and triggers a debounced save to the repository.
  void updateWeight(double? newWeight) {
    _weight = newWeight;
    _errorMessage = null;
    _debouncer.run(() => _saveWeight(newWeight));
  }

  Future<void> _saveWeight(double? weight) async {
    try {
      await repository.setCurrentWeight(exerciseName, weight);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to save weight for $exerciseName: $e');
      _errorMessage = 'Failed to save weight.';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _debouncer.cancel();
    super.dispose();
  }
}
