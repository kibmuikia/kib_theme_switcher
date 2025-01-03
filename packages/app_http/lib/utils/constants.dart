import 'dart:async' show FutureOr;

import 'package:app_http/utils/api_error.dart' show ApiError;
import 'package:dio/dio.dart' show DioException;

class ApiConstants {
  const ApiConstants._();

  // Base URLs
  static const String baseUrlDev = 'https://api.dev.example.com';
  static const String baseUrlProd = 'https://api.example.com';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}

const String errorEncountered = "Error Encountered";
const String success = "Success";

/// Type definition for response transformation function
typedef ResponseTransformer<T> = FutureOr<T> Function(T data);

/// Type definition for custom error handling function
typedef DioExceptionHandler = Future<ApiError> Function(
    String url, DioException error);
