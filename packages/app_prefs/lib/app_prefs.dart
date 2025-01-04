library app_prefs;

import 'package:app_prefs/managers/export.dart';

export 'package:app_prefs/managers/export.dart';

/// Manages application preferences through specialized managers for different domains
/// such as app settings, authentication, and theming.
///
/// Usage:
/// ```dart
/// // Initialize preferences
/// await AppPrefs.init();
///
/// // Access specific managers
/// AppPrefs.theme.isDarkMode;
/// AppPrefs.auth.isLoggedIn;
/// ```
class AppPrefs {
  // Private constructor to prevent instantiation
  AppPrefs._();

  /// Flag to track initialization status
  static bool _initialized = false;

  /// Whether AppPrefs has been initialized
  static bool get isInitialized => _initialized;

  /// Manager for general application preferences
  static late final AppAsyncPrefsManager app;

  /// Manager for authentication-related preferences
  static late final AuthPrefsManager auth;

  /// Manager for theme-related preferences
  static late final ThemeCachedPrefsManager theme;

  /// Initializes all preference managers.
  ///
  /// Should be called at app startup before accessing any preferences.
  /// Throws a [StateError] if called more than once.
  static Future<void> init() async {
    if (_initialized) {
      throw StateError('AppPrefs has already been initialized');
    }

    try {
      app = AppAsyncPrefsManager();
      auth = AuthPrefsManager();
      theme = ThemeCachedPrefsManager();

      await Future.wait([
        app.init(),
        auth.init(),
        theme.init(),
      ]);

      _initialized = true;
    } catch (e, trace) {
      _initialized = false;
      throw StateError('Failed to initialize AppPrefs: $e\n$trace');
    }
  }

  /// Disposes all managers and cleans up resources.
  ///
  /// Should be called when the app is terminating or preferences
  /// are no longer needed.
  static Future<void> clearAll() async {
    if (!_initialized) return;

    await Future.wait([
      app.clear(),
      auth.clear(),
      theme.clear(),
    ]);

    _initialized = false;
  }
}
