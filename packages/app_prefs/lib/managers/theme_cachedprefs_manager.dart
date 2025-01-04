import 'package:app_prefs/base/export.dart' show BasePrefsCached;

class ThemeCachedPrefsManager extends BasePrefsCached {
  static const _prefix = 'theme_';
  static const _keyThemeMode = 'mode';
  static const _keyCustomTheme = 'custom';

  ThemeCachedPrefsManager()
      : super(
    prefix: _prefix,
    allowList: {_keyThemeMode, _keyCustomTheme},
  );

  Future<bool> setThemeMode(String mode) => setValue<String>(_keyThemeMode, mode);
  String? getThemeMode() => getValue<String>(_keyThemeMode);
}
