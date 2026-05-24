import 'package:flutter_test/flutter_test.dart';
import 'package:workout/features/workout/domain/exercise.dart';

void main() {
  test('Exercise constructs and warmupInfo is callable', () {
    final exerciseInfo = Exercise(
      name: 'Test',
      warmupInfo: (w) => 'called $w',
    );
    expect(exerciseInfo.name, 'Test');
    expect(exerciseInfo.warmupInfo?.call(10.0), 'called 10.0');
  });
}