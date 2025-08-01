import 'package:flutter_test/flutter_test.dart';
import 'package:workout/features/workout/domain/exercise_info.dart';

void main() {
  test('ExerciseInfo constructs and warmupInfo is callable', () {
    final exerciseInfo = ExerciseInfo(
      name: 'Test',
      warmupInfo: (w) => 'called $w',
    );
    expect(exerciseInfo.name, 'Test');
    expect(exerciseInfo.warmupInfo(10.0), 'called 10.0');
  });
}