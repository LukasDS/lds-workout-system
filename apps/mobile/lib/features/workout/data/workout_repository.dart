/// A repository interface for managing workout exercises.
abstract class WorkoutRepository {
  Future<double?> getCurrentWeight(String exerciseName);
  Future<void> setCurrentWeight(String exerciseName, double? weight);
}