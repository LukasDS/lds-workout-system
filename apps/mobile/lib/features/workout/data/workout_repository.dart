/// A repository interface for managing workout exercises.
abstract class WorkoutRepository {
  Stream<double?> watchCurrentWeight(String exerciseName);
  Future<void> setCurrentWeight(String exerciseName, double? weight);
}