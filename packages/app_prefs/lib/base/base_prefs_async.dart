import 'package:app_prefs/base/base_prefs.dart' show BasePrefs;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferencesAsync;

/// Base class for async preferences management
abstract class BasePrefsAsync extends BasePrefs {
  /// The async preferences instance
  late final SharedPreferencesAsync _prefs;
  /// Whether preferences have been initialized
  bool _initialized = false;

  BasePrefsAsync({
    required super.prefix,
    super.allowUnprefixed,
    super.allowList,
  });

  /// Initialize the preferences
  Future<bool> init() async {
    try {
      if (_initialized) {
        debugPrint('** BasePrefsAsync: Already initialized *');
        return true;
      }
      _prefs = SharedPreferencesAsync();
      _initialized = true;
      return _initialized;
    } on Exception catch (e) {
      debugPrint('** BasePrefsAsync:init: $e *');
      _initialized = false;
      return _initialized;
    }
  }

  /// Checks if the preferences are initialized
  ///
  /// [throwOnError] - If true, throws a [StateError] when not initialized
  /// Returns true if initialized, false otherwise (when [throwOnError] is false)
  /// Throws [StateError] when not initialized and [throwOnError] is true
  bool checkInitialized({bool throwOnError = false}) {
    if (!_initialized && throwOnError) {
      throw StateError('BasePrefsAsync not initialized. Call init() before using preferences.');
    }
    return _initialized;
  }

  /// Get a value from preferences
  Future<T?> getValue<T>(String key) async {
    try {
      // Will return false if not initialized instead of throwing
      if (!checkInitialized()) return null;
      if (key.isEmpty) return null;

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
    } on Exception catch (e) {
      debugPrint('** BasePrefsAsync:getValue:[$key] $e *');
      return null;
    }
  }

  /// Set a value in preferences
  Future<bool> setValue<T>(String key, T value) async {
    try {
      // Will return false if not initialized instead of throwing
      if (!checkInitialized()) return false;
      if (key.isEmpty) return false;

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
    } on Exception catch (e) {
      debugPrint('** BasePrefsAsync:setValue:[$key - $value] $e *');
      return false;
    }
  }

  /// Remove a value from preferences
  Future<bool> removeValue(String key) async {
    try {
      // Will return false if not initialized instead of throwing
      if (!checkInitialized()) return false;
      if (key.isEmpty) return false;

      final fullKey = getPrefixedKey(key);
      if (!isKeyAllowed(fullKey)) return false;
      await _prefs.remove(fullKey);
      return true;
    } on Exception catch (e) {
      debugPrint('** BasePrefsAsync:removeValue:[$key] $e *');
      return false;
    }
  }

  /// Clear all values
  Future<bool> clear() async {
    try {
      // Will return false if not initialized instead of throwing
      if (!checkInitialized()) return false;

      await _prefs.clear();
      return true;
    } on Exception catch (e) {
      debugPrint('** BasePrefsAsync:clear: $e *');
      return false;
    }
  }
}
