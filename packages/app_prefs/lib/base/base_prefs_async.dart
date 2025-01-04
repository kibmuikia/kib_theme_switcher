import 'package:app_prefs/base/base_prefs.dart' show BasePrefs;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferencesAsync;

/// Base class for async preferences management
abstract class BasePrefsAsync extends BasePrefs {
  /// The async preferences instance
  late final SharedPreferencesAsync _prefs;

  BasePrefsAsync({
    required super.prefix,
    super.allowUnprefixed,
    super.allowList,
  });

  /// Initialize the preferences
  Future<void> init() async {
    _prefs = SharedPreferencesAsync();
  }

  /// Get a value from preferences
  Future<T?> getValue<T>(String key) async {
    try {
      final fullKey = getPrefixedKey(key);
      if (!isKeyAllowed(fullKey)) return null;

      switch (T) {
        case int:
          return (await _prefs.getInt(fullKey)) as T?;
        case double:
          return (await _prefs.getDouble(fullKey)) as T?;
        case bool:
          return (await _prefs.getBool(fullKey)) as T?;
        case String:
          return (await _prefs.getString(fullKey)) as T?;
        case const (List<String>):
          return (await _prefs.getStringList(fullKey)) as T?;
        default:
          throw UnsupportedError('Type $T not supported by SharedPreferences');
      }
    } on Exception catch (_) {
      return null;
    }
  }

  /// Set a value in preferences
  Future<bool> setValue<T>(String key, T value) async {
    try {
      final fullKey = getPrefixedKey(key);
      if (!isKeyAllowed(fullKey)) return false;

      switch (T) {
        case int:
          await _prefs.setInt(fullKey, value as int);
          return true;
        case double:
          await _prefs.setDouble(fullKey, value as double);
          return true;
        case bool:
          await _prefs.setBool(fullKey, value as bool);
          return true;
        case String:
          await _prefs.setString(fullKey, value as String);
          return true;
        case const (List<String>):
          await _prefs.setStringList(fullKey, value as List<String>);
          return true;
        default:
          throw UnsupportedError('Type $T not supported by SharedPreferences');
      }
    } on Exception catch (_) {
      return false;
    }
  }

  /// Remove a value from preferences
  Future<bool> removeValue(String key) async {
    try {
      final fullKey = getPrefixedKey(key);
      if (!isKeyAllowed(fullKey)) return false;
      await _prefs.remove(fullKey);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  /// Clear all values
  Future<bool> clear() async {
    try {
      await _prefs.clear();
      return true;
    } on Exception catch (e) {
      return false;
    }
  }
}
