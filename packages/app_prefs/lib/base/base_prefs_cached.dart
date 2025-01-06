import 'package:app_prefs/base/base_prefs.dart' show BasePrefs;
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesWithCache, SharedPreferencesWithCacheOptions;

/// Base class for cached preferences management
abstract class BasePrefsCached extends BasePrefs {
  /// The cached preferences instance
  late final SharedPreferencesWithCache _prefs;

  /// Whether preferences have been initialized
  bool _initialized = false;

  BasePrefsCached({
    required super.prefix,
    super.allowUnprefixed,
    super.allowList,
  });

  /// Initialize the preferences
  Future<bool> init(String managerName) async {
    try {
      if (_initialized) {
        kprint.warn('BasePrefsCached: Already initialized');
        return true;
      }
      _prefs = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: allowList,
        ),
      );
      _initialized = true;
      kprint.lg('initialized $managerName', symbol: '💾');
      return _initialized;
    } on Exception catch (e) {
      kprint.err('BasePrefsCached:init: $e');
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
      throw StateError(
          'BasePrefsCached not initialized. Call init() before using preferences.');
    }
    return _initialized;
  }

  /// Get a value from preferences synchronously
  T? getValue<T>(String key) {
    try {
      // Will return false if not initialized instead of throwing
      if (!checkInitialized()) return null;
      if (key.isEmpty) return null;

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
    } on Exception catch (e) {
      kprint.err('BasePrefsCached:getValue:[$key]: $e');
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
      kprint.err('BasePrefsCached:setValue:[$key - $value]: $e');
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
      kprint.err('BasePrefsCached:removeValue:[$key]: $e');
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
      kprint.err('BasePrefsCached:clear: $e');
      return false;
    }
  }

  /// Reload preferences from disk
  Future<void> reload() async {
    try {
      // Will return false if not initialized instead of throwing
      if (!checkInitialized()) return;

      await _prefs.reloadCache();
    } on Exception catch (e) {
      kprint.err('BasePrefsCached:reload: $e');
    }
  }

//
}
