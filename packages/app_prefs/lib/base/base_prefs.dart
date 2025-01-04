import 'package:shared_preferences/shared_preferences.dart';

/// Abstract base class for all preference managers
abstract class BasePrefs {
  /// The prefix for all keys in this preference manager
  final String prefix;

  /// Whether to handle keys without prefixes
  final bool allowUnprefixed;

  /// List of allowed keys (optional)
  final Set<String>? allowList;

  const BasePrefs({
    required this.prefix,
    this.allowUnprefixed = false,
    this.allowList,
  });

  /// Get the full key with prefix
  String getPrefixedKey(String key) => allowUnprefixed ? key : '$prefix$key';

  /// Remove prefix from key
  String removePrefixFromKey(String key) {
    if (allowUnprefixed || !key.startsWith(prefix)) return key;
    return key.substring(prefix.length);
  }

  /// Check if a key is allowed
  bool isKeyAllowed(String key) {
    if (allowList == null) return true;
    return allowList!.contains(removePrefixFromKey(key));
  }
}
