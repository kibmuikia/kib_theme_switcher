import 'package:app_prefs/base/base_prefs.dart' show BasePrefs;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesWithCache, SharedPreferencesWithCacheOptions;

/// Base class for cached preferences management
abstract class BasePrefsCached extends BasePrefs {
  /// The cached preferences instance
  late final SharedPreferencesWithCache _prefs;

  BasePrefsCached({
    required super.prefix,
    super.allowUnprefixed,
    super.allowList,
  });

  /// Initialize the preferences
  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: allowList,
      ),
    );
  }

  /// Get a value from preferences synchronously
  T? getValue<T>(String key) {
    try {
      final fullKey = getPrefixedKey(key);
      if (!isKeyAllowed(fullKey)) return null;

      switch (T) {
        case int:
          return _prefs.getInt(fullKey) as T?;
        case double:
          return _prefs.getDouble(fullKey) as T?;
        case bool:
          return _prefs.getBool(fullKey) as T?;
        case String:
          return _prefs.getString(fullKey) as T?;
        case const (List<String>):
          return _prefs.getStringList(fullKey) as T?;
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
    } on Exception catch (_) {
      return false;
    }
  }

  /// Reload preferences from disk
  Future<void> reload() async {
    try {
      await _prefs.reloadCache();
    } on Exception catch (e) {
      debugPrint('BasePrefsCached:reload: $e');
    }
  }

//
}
