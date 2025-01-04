import 'package:app_prefs/base/export.dart' show BasePrefsAsync;

class AuthPrefsManager extends BasePrefsAsync {
  static const _prefix = 'auth_';
  static const _keyToken = 'token';
  static const _keyUserId = 'user_id';
  static const _keyLastLogin = 'last_login';

  AuthPrefsManager()
      : super(
    prefix: _prefix,
    allowList: {_keyToken, _keyUserId, _keyLastLogin},
  );

  Future<String?> getToken() => getValue<String>(_keyToken);
  Future<bool> setToken(String token) => setValue<String>(_keyToken, token);
  Future<bool> clearToken() => removeValue(_keyToken);

  Future<String?> getUserId() => getValue<String>(_keyUserId);
  Future<bool> setUserId(String userId) => setValue<String>(_keyUserId, userId);
}
