/// A local storage interface for storing and retrieving integer values.
abstract class LocalStorage {
  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);
}