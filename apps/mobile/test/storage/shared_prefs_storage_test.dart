import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/core/storage/shared_prefs_storage.dart';

void main() {
  group('SharedPrefsStorage', () {
    late SharedPrefsStorage storage;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'existing_key': 123,
      });
      prefs = await SharedPreferences.getInstance();
      storage = SharedPrefsStorage(prefs);
    });

    test('getInt returns value if key exists', () async {
      final value = await storage.getInt('existing_key');
      expect(value, 123);
    });

    test('getInt returns null if key does not exist', () async {
      final value = await storage.getInt('non_existent_key');
      expect(value, null);
    });

    test('setInt saves value correctly', () async {
      await storage.setInt('new_key', 456);
      expect(prefs.getInt('new_key'), 456);
    });
  });
}
