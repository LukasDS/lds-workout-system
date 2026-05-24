import 'package:flutter_test/flutter_test.dart';
import 'package:workout/core/utils/warmup_utils.dart';

void main() {
  group('warmup_utils', () {
    test('formatWeightInfo handles whole numbers', () {
      expect(formatWeightInfo(10), '10');
      expect(formatWeightInfo(10.0), '10');
    });

    test('formatWeightInfo handles decimals', () {
      expect(formatWeightInfo(10.5), '10.50');
      expect(formatWeightInfo(10.55), '10.55');
    });

    test('formatWeightInfo handles negative weights (dumbbells)', () {
      expect(formatWeightInfo(-10, 20), '10d'); // -10 + 20 = 10
      expect(formatWeightInfo(-10.5, 20), '9.50d'); // -10.5 + 20 = 9.5
      expect(formatWeightInfo(-10.0, 20), '10d');
    });

    test('getDefaultWarmupInfo', () {
      expect(getDefaultWarmupInfo(null), '');
      expect(getDefaultWarmupInfo(100), '20-30,  60,  80');
    });

    test('getGenericBarbellWarmupInfo', () {
      expect(getGenericBarbellWarmupInfo(null, 20), '');
      // Weight = 100, Barbell = 20
      // halfBar = 10
      // 20%: (100+10)*0.2 - 10 = 110*0.2 - 10 = 22 - 10 = 12
      // 30%: (100+10)*0.3 - 10 = 110*0.3 - 10 = 33 - 10 = 23
      // 60%: 110*0.6 - 10 = 66 - 10 = 56
      // 80%: 110*0.8 - 10 = 88 - 10 = 78
      expect(getGenericBarbellWarmupInfo(100, 20), '12-23,  56,  78');
    });

    test('getBarbellWarmupInfo uses 20kg bar', () {
      expect(getBarbellWarmupInfo(100), '12-23,  56,  78');
    });

    test('getEzBarWarmupInfo uses 7.5kg bar', () {
      // Weight = 100, Barbell = 7.5, halfBar = 3.75
      // 20%: 103.75*0.2 - 3.75 = 20.75 - 3.75 = 17
      // 30%: 103.75*0.3 - 3.75 = 31.125 - 3.75 = 27.375 -> 27.38
      // 60%: 103.75*0.6 - 3.75 = 62.25 - 3.75 = 58.5
      // 80%: 103.75*0.8 - 3.75 = 83 - 3.75 = 79.25
      expect(getEzBarWarmupInfo(100), '17-27.38,  58.50,  79.25');
    });

    test('getWeightedDipsWarmupInfo', () {
      expect(getWeightedDipsWarmupInfo(10), '12 D press,  18 Tricep ext,  0 Dips');
    });

    test('getPullUpsDynamicStretchingInfo', () {
      expect(getPullUpsDynamicStretchingInfo(0), contains('Scapular pull-ups'));
    });

    test('getDipsDynamicStretchingInfo', () {
      expect(getDipsDynamicStretchingInfo(0), contains('Tricep extensions'));
    });

    test('getApertureLWarmupInfo', () {
      expect(getApertureLWarmupInfo(null), '');
      expect(getApertureLWarmupInfo(10), '5.0');
    });
  });
}
