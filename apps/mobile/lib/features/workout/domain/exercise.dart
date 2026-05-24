class Exercise {
  final String name;
  final bool requiresWeight;
  final String Function(double?)? warmupInfo;

  const Exercise({required this.name, this.warmupInfo, this.requiresWeight = true});
}
