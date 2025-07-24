import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout/features/workout/data/workout_repository.dart';

/// A repository for managing workout exercises using Firebase Firestore.
///
class FirebaseWorkoutRepository extends WorkoutRepository {
  final FirebaseFirestore firestore;
  final String collectionName;

  FirebaseWorkoutRepository(this.firestore, {this.collectionName = 'lukas_exercises'});

  /// Retrieves the current weight for a given exercise name.
  /// Returns null if the exercise does not exist or has no current weight set.
  /// Throws an exception if the operation fails.
  @override
  Future<double?> getCurrentWeight(String exerciseName) async {
    final doc = await firestore.collection(collectionName).doc(exerciseName).get();
    return doc.exists ? doc.get('currentWeight') as double? : null;
  }

  /// Sets the current weight for an exercise and updates the history.
  /// If weight is null, it clears the current weight.
  /// If weight is provided, it updates the current weight and adds a new entry to the history.
  /// Throws an exception if the operation fails.
  @override
  Future<void> setCurrentWeight(String exerciseName, double? weight) async {
    final exerciseDoc = firestore.collection(collectionName).doc(exerciseName);
    if (weight != null) {
      await firestore.runTransaction((transaction) async {
        // Update the current weight
        transaction.set(exerciseDoc, {'currentWeight': weight}, SetOptions(merge: true));

        // Add the new weight to the history
        transaction.set(exerciseDoc.collection('history').doc(), {
          'weight': weight,
          'date': Timestamp.now()
        });
      });
    } else {
      exerciseDoc.set({'currentWeight': null}, SetOptions(merge: true));
    }
  }
}