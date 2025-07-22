import 'package:flutter_test/flutter_test.dart';
import 'package:workout/utils/debouncer.dart';

void main() {
  test('Debouncer calls action after delay', () async {
    final debouncer = Debouncer(milliseconds: 100);
    bool called = false;

    debouncer.run(() { called = true; });

    await Future.delayed(const Duration(milliseconds: 150));
    expect(called, true);
  });

  test('Debouncer does not call action if cancelled', () async {
    final debouncer = Debouncer(milliseconds: 100);
    bool called = false;

    debouncer.run(() { called = true; });
    debouncer.cancel();

    await Future.delayed(const Duration(milliseconds: 150));
    expect(called, false);
  });
}