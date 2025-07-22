import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/storage/local_storage.dart';

/// A shared preferences implementation of the LocalStorage interface.
class SharedPrefsStorage extends LocalStorage {
  /// Retrieves an integer value from shared preferences.
  @override
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  /// Sets an integer value in shared preferences.
  @override
  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}