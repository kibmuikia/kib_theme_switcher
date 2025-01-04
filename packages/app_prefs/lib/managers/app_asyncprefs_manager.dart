import 'package:app_prefs/base/export.dart' show BasePrefsAsync;

class AppAsyncPrefsManager extends BasePrefsAsync {
  static const _prefix = 'app_';
  static const _keyFirstLaunch = 'first_launch';
  static const _keyLastVersion = 'last_version';
  static const _keyLanguage = 'language';

  AppAsyncPrefsManager()
      : super(
    prefix: _prefix,
    allowList: {_keyFirstLaunch, _keyLastVersion, _keyLanguage},
  );

  Future<bool?> isFirstLaunch() => getValue(_keyFirstLaunch);
  Future<bool> setFirstLaunch(bool value) => setValue(_keyFirstLaunch, value);

  Future<String?> getLanguage() => getValue(_keyLanguage);
  Future<bool> setLanguage(String language) => setValue(_keyLanguage, language);
}
