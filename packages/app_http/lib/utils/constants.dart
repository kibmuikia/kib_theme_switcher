class ApiConstants {
  const ApiConstants._();

  // Base URLs
  static const String baseUrlDev = 'https://api.dev.example.com';
  static const String baseUrlProd = 'https://api.example.com';

  // API Versions
  static const String v1 = '/v1';
  static const String v2 = '/v2';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // API Endpoints
  static const String users = '/users';
  static const String posts = '/posts';
  static const String comments = '/comments';
}
