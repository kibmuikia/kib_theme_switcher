import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment configuration for development
@Envied(path: '.env.dev', obfuscate: true)
abstract class EnvDev {
  @EnviedField(varName: 'API_BASE_URL')
  static String baseUrl = _EnvDev.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static String apiKey = _EnvDev.apiKey;

}

/// Environment configuration for production
@Envied(path: '.env.prod', obfuscate: true)
abstract class EnvProd {
  @EnviedField(varName: 'API_BASE_URL')
  static String baseUrl = _EnvProd.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static String apiKey = _EnvProd.apiKey;
}

/// Environment configuration wrapper
class Env {
  /// Whether we're running in production mode
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  /// Get the base URL for the current environment
  static String get baseUrl => isProduction ? EnvProd.baseUrl : EnvDev.baseUrl;

  /// Get the API key for the current environment
  static String get apiKey => isProduction ? EnvProd.apiKey : EnvDev.apiKey;
}
