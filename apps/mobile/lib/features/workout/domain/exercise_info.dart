class ExerciseInfo {
  final String name;
  final bool requiresWeight;
  final String Function(double?) warmupInfo;

  const ExerciseInfo({required this.name, required this.warmupInfo, this.requiresWeight = true});
}
