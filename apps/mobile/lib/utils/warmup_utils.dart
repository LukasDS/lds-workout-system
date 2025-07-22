String formatWeightInfo(double weight, [double halfBarbellWeight = 0]) {
  if (weight < 0) {
    double dumbellWeight = weight + halfBarbellWeight;
    if (dumbellWeight % 1 == 0) {
      return '${dumbellWeight.toInt()}d';
    }

    return '${dumbellWeight.toStringAsFixed(2)}d';
  }

  if (weight % 1 == 0) {
    return weight.toInt().toString();
  }

  return weight.toStringAsFixed(2);
}

String getDefaultWarmupInfo(double? weight) {
  if (weight == null) return '';

  String firstSetLowestWeight = formatWeightInfo(weight * 0.2);
  String firstSetHighestWeight = formatWeightInfo(weight * 0.3);
  String secondSetWeight = formatWeightInfo(weight * 0.6);
  String thirdSetWeight = formatWeightInfo(weight * 0.8);

  return '$firstSetLowestWeight-$firstSetHighestWeight,  $secondSetWeight,  $thirdSetWeight';
}

String getGenericBarbellWarmupInfo(double? weight, double barbellWeight) {
  if (weight == null) return '';

  double halfBarbellWeight = barbellWeight / 2;

  String firstSetLowestWeight = formatWeightInfo(
      (weight + halfBarbellWeight) * 0.2 - halfBarbellWeight,
      halfBarbellWeight);
  String firstSetHighestWeight = formatWeightInfo(
      (weight + halfBarbellWeight) * 0.3 - halfBarbellWeight,
      halfBarbellWeight);
  String secondSetWeight = formatWeightInfo(
      (weight + halfBarbellWeight) * 0.6 - halfBarbellWeight,
      halfBarbellWeight);
  String thirdSetWeight = formatWeightInfo(
      (weight + halfBarbellWeight) * 0.8 - halfBarbellWeight,
      halfBarbellWeight);

  return '$firstSetLowestWeight-$firstSetHighestWeight,  $secondSetWeight,  $thirdSetWeight';
}

String getBarbellWarmupInfo(double? weight) =>
    getGenericBarbellWarmupInfo(weight, 20);

String getEzBarWarmupInfo(double? weight) =>
    getGenericBarbellWarmupInfo(weight, 7.5);

String getDipsWarmupInfo(double? weight) =>
    '12 D press,  18 Tricep ext,  0 Dips'; // Until 20 kg is reached, then normal warmup

String getApertureLWarmupInfo(double? weight) =>
    weight == null ? '' : '${weight * 0.5}';