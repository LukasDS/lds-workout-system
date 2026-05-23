import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/core/storage/local_storage.dart';

/// A shared preferences implementation of the LocalStorage interface.
class SharedPrefsStorage extends LocalStorage {
  final SharedPreferences prefs;
  SharedPrefsStorage(this.prefs);

  /// Retrieves an integer value from shared preferences.
  @override
  Future<int?> getInt(String key) async {
    return prefs.getInt(key);
  }

  /// Sets an integer value in shared preferences.
  @override
  Future<void> setInt(String key, int value) async {
    await prefs.setInt(key, value);
  }
}