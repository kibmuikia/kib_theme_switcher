import 'package:app_http/utils/export.dart'
    show
        ApiConstants,
        ApiError,
        ApiResponse,
        HttpValidator,
        RetryOptions,
        errorEncountered,
        success;
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart' show RetryInterceptor;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' show PrettyDioLogger;

/// A service class that handles HTTP requests using Dio client.
///
/// Provides a robust HTTP client service with:
/// - Environment-specific configurations (development/production)
/// - Built-in error handling and standardized API responses
/// - Optional request/response logging
/// - Progress tracking for uploads and downloads
/// - Support for all standard HTTP methods (GET, POST, PUT, PATCH, DELETE)
///
/// Usage:
/// ```dart
/// // Create instance for development with logging
/// final service = ServerService.development(enableLogging: true);
///
/// // Make requests
/// final response = await service.get<Map<String, dynamic>>('/users');
/// ```
class ServerService {
  final Dio _dio;

  /// Whether to enable detailed request/response logging.
  final bool enableLogging;

  /// Whether retry mechanism is enabled
  final bool enableRetry;

  /// Private constructor to prevent direct instantiation.
  ///
  /// Creates a configured Dio instance with:
  /// - Base URL configuration
  /// - Timeout settings from [ApiConstants]
  /// - Status validation
  /// - Optional logging interceptor
  ///
  /// Parameters:
  /// - [baseUrl]: The base URL for all requests
  /// - [enableLogging]: Whether to enable request/response logging
  ServerService._({
    required String baseUrl,
    this.enableLogging = false,
    this.enableRetry = false,
    Map<String, dynamic>? headers,
    RetryOptions? retryOptions,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: ApiConstants.connectionTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            validateStatus: (status) => HttpValidator.isValidStatus(status),
            headers: headers,
            queryParameters: null,
            extra: null,
            contentType: null,
          ),
        ) {
    if (enableLogging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
    // Add retry interceptor if enabled
    if (enableRetry) {
      _dio.interceptors.add(
        RetryInterceptor(
          dio: _dio,
          logPrint: enableLogging ? print : null,
          // Use custom retry options if provided, otherwise use defaults
          retries: retryOptions?.retries ?? 3,
          retryDelays: retryOptions?.retryDelays ??
              const [
                Duration(seconds: 1),
                Duration(seconds: 2),
                Duration(seconds: 3),
              ],
          retryEvaluator: retryOptions?.retryEvaluator,
          retryableExtraStatuses:
              retryOptions?.retryableExtraStatuses ?? const {},
        ),
      );
    }
  }

  /// Creates a ServerService instance configured for development environment.
  ///
  /// Parameters:
  /// - [enableLogging]: Whether to enable request/response logging (defaults to false)
  /// - [enableRetry]: Whether to enable retry mechanism (defaults to false)
  /// - [retryOptions]: Optional custom retry configuration
  ///
  /// Returns a new [ServerService] instance with development base URL.
  /// Note: This is a factory constructor for development environment
  factory ServerService.development({
    bool enableLogging = false,
    bool enableRetry = false,
    RetryOptions? retryOptions,
    Map<String, dynamic>? headers,
  }) {
    return ServerService._(
      baseUrl: ApiConstants.baseUrlDev,
      enableLogging: enableLogging,
      enableRetry: enableRetry,
      retryOptions: retryOptions,
      headers: headers,
    );
  }

  /// Creates a ServerService instance configured for production environment.
  ///
  /// Parameters:
  /// - [enableLogging]: Whether to enable request/response logging (defaults to false)
  /// - [enableRetry]: Whether to enable retry mechanism (defaults to false)
  /// - [retryOptions]: Optional custom retry configuration
  ///
  /// Returns a new [ServerService] instance with production base URL.
  /// Note: This is a factory constructor for production environment
  factory ServerService.production({
    bool enableLogging = false,
    bool enableRetry = false,
    RetryOptions? retryOptions,
    Map<String, dynamic>? headers,
  }) {
    return ServerService._(
      baseUrl: ApiConstants.baseUrlProd,
      enableLogging: enableLogging,
      enableRetry: enableRetry,
      retryOptions: retryOptions,
      headers: headers,
    );
  }

  /// Gets the current headers
  Map<String, dynamic> get headers => _dio.options.headers;

  /// Sets default headers for all requests
  /// This will override any existing headers
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers = headers;
  }

  /// Updates existing headers
  /// This will merge new headers with existing ones
  void updateHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Removes specific headers by their keys
  void removeHeaders(List<String> headerKeys) {
    for (final key in headerKeys) {
      _dio.options.headers.remove(key);
    }
  }

  /// Clears all headers
  void clearHeaders() {
    _dio.options.headers.clear();
  }

  /// Sets an authorization token in the headers
  void setAuthToken(String token) {
    _dio.options.headers[ApiConstants.authorization] =
        '${ApiConstants.bearer} $token';
  }

  /// Removes the authorization token from headers
  void removeAuthToken() {
    _dio.options.headers.remove(ApiConstants.authorization);
  }

  /// Generic GET request
  /// Performs a GET request to the specified path and returns a standardized [ApiResponse].
  ///
  /// Parameters:
  /// - [path]: The URL path to request
  /// - [queryParameters]: Optional query parameters to append to URL
  /// - [options]: Optional Dio request options
  /// - [cancelToken]: Optional token for cancelling the request
  /// - [onReceiveProgress]: Optional callback for tracking download progress
  ///
  /// Returns an [ApiResponse<T>] containing:
  /// - Success case: Response data, status code, and success message
  /// - Error case: Error details, status code, and error message
  ///
  /// The method handles network errors, timeout errors, and unexpected exceptions
  /// by wrapping them in an error [ApiResponse] rather than throwing.
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress == null
            ? null
            : (i, o) => onReceiveProgress(i, o),
      );
      final defaultMessage = response.statusMessage ?? success;

      return ApiResponse.success(
        url: path,
        data: response.data,
        statusCode: response.statusCode,
        message: defaultMessage,
      );
    } on DioException catch (e) {
      final apiError = _handleDioError(path, e);
      return ApiResponse.error(
        url: path,
        apiError: apiError,
        message: e.type.name,
        statusCode: e.response?.statusCode,
      );
    } on Exception catch (e, trace) {
      final apiError =
          ApiError(url: path, message: "${e.toString()},\n: $trace", error: e);
      return ApiResponse.error(
          url: path, apiError: apiError, message: errorEncountered);
    }
  }

  /// Generic POST request
  /// Performs a POST request to the specified path and returns a standardized [ApiResponse].
  ///
  /// Parameters:
  /// - [path]: The URL path to request
  /// - [data]: The data to send in request body
  /// - [queryParameters]: Optional query parameters to append to URL
  /// - [options]: Optional Dio request options
  /// - [cancelToken]: Optional token for cancelling the request
  /// - [onSendProgress]: Optional callback for tracking upload progress
  /// - [onReceiveProgress]: Optional callback for tracking download progress
  ///
  /// Returns an [ApiResponse<T>] containing:
  /// - Success case: Response data, status code, and success message
  /// - Error case: Error details, status code, and error message
  ///
  /// The method handles network errors, timeout errors, and unexpected exceptions
  /// by wrapping them in an error [ApiResponse] rather than throwing.
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress:
            onSendProgress == null ? null : (i, o) => onSendProgress(i, o),
        onReceiveProgress: onReceiveProgress == null
            ? null
            : (i, o) => onReceiveProgress(i, o),
      );
      final defaultMessage = response.statusMessage ?? success;

      return ApiResponse.success(
        url: path,
        data: response.data,
        statusCode: response.statusCode,
        message: defaultMessage,
      );
    } on DioException catch (e) {
      final apiError = _handleDioError(path, e);
      return ApiResponse.error(
        url: path,
        apiError: apiError,
        message: e.type.name,
        statusCode: e.response?.statusCode,
      );
    } on Exception catch (e, trace) {
      final apiError =
          ApiError(url: path, message: "${e.toString()},\n: $trace", error: e);
      return ApiResponse.error(
          url: path, apiError: apiError, message: errorEncountered);
    }
  }

  /// Generic PUT request
  /// Performs a PUT request to the specified path and returns a standardized [ApiResponse].
  ///
  /// Parameters:
  /// - [path]: The URL path to request
  /// - [data]: The data to send in request body
  /// - [queryParameters]: Optional query parameters to append to URL
  /// - [options]: Optional Dio request options
  /// - [cancelToken]: Optional token for cancelling the request
  /// - [onSendProgress]: Optional callback for tracking upload progress
  /// - [onReceiveProgress]: Optional callback for tracking download progress
  ///
  /// Returns an [ApiResponse<T>] containing:
  /// - Success case: Response data, status code, and success message
  /// - Error case: Error details, status code, and error message
  ///
  /// The method handles network errors, timeout errors, and unexpected exceptions
  /// by wrapping them in an error [ApiResponse] rather than throwing.
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress:
            onSendProgress != null ? (i, o) => onSendProgress(i, o) : null,
        onReceiveProgress: onReceiveProgress != null
            ? (i, o) => onReceiveProgress(i, o)
            : null,
      );
      final defaultMessage = response.statusMessage ?? success;

      return ApiResponse.success(
        url: path,
        data: response.data,
        statusCode: response.statusCode,
        message: defaultMessage,
      );
    } on DioException catch (e) {
      final apiError = _handleDioError(path, e);
      return ApiResponse.error(
        url: path,
        apiError: apiError,
        message: e.type.name,
        statusCode: e.response?.statusCode,
      );
    } on Exception catch (e, trace) {
      final apiError =
          ApiError(url: path, message: "${e.toString()},\n: $trace", error: e);
      return ApiResponse.error(
          url: path, apiError: apiError, message: errorEncountered);
    }
  }

  /// Generic PATCH request
  /// Performs a PATCH request to the specified path and returns a standardized [ApiResponse].
  ///
  /// Parameters:
  /// - [path]: The URL path to request
  /// - [data]: The data to send in request body
  /// - [queryParameters]: Optional query parameters to append to URL
  /// - [options]: Optional Dio request options
  /// - [cancelToken]: Optional token for cancelling the request
  /// - [onSendProgress]: Optional callback for tracking upload progress
  /// - [onReceiveProgress]: Optional callback for tracking download progress
  ///
  /// Returns an [ApiResponse<T>] containing:
  /// - Success case: Response data, status code, and success message
  /// - Error case: Error details, status code, and error message
  ///
  /// The method handles network errors, timeout errors, and unexpected exceptions
  /// by wrapping them in an error [ApiResponse] rather than throwing.
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress:
            onSendProgress != null ? (i, o) => onSendProgress(i, o) : null,
        onReceiveProgress: onReceiveProgress != null
            ? (i, o) => onReceiveProgress(i, o)
            : null,
      );
      final defaultMessage = response.statusMessage ?? success;

      return ApiResponse.success(
        url: path,
        data: response.data,
        statusCode: response.statusCode,
        message: defaultMessage,
      );
    } on DioException catch (e) {
      final apiError = _handleDioError(path, e);
      return ApiResponse.error(
        url: path,
        apiError: apiError,
        message: e.type.name,
        statusCode: e.response?.statusCode,
      );
    } on Exception catch (e, trace) {
      final apiError =
          ApiError(url: path, message: "${e.toString()},\n: $trace", error: e);
      return ApiResponse.error(
          url: path, apiError: apiError, message: errorEncountered);
    }
  }

  /// Generic DELETE request
  /// Performs a DELETE request to the specified path and returns a standardized [ApiResponse].
  ///
  /// Parameters:
  /// - [path]: The URL path to request
  /// - [data]: Optional data to send in request body
  /// - [queryParameters]: Optional query parameters to append to URL
  /// - [options]: Optional Dio request options
  /// - [cancelToken]: Optional token for cancelling the request
  ///
  /// Returns an [ApiResponse<T>] containing:
  /// - Success case: Response data, status code, and success message
  /// - Error case: Error details, status code, and error message
  ///
  /// The method handles network errors, timeout errors, and unexpected exceptions
  /// by wrapping them in an error [ApiResponse] rather than throwing.
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      final defaultMessage = response.statusMessage ?? success;

      return ApiResponse.success(
        url: path,
        data: response.data,
        statusCode: response.statusCode,
        message: defaultMessage,
      );
    } on DioException catch (e) {
      final apiError = _handleDioError(path, e);
      return ApiResponse.error(
        url: path,
        apiError: apiError,
        message: e.type.name,
        statusCode: e.response?.statusCode,
      );
    } on Exception catch (e, trace) {
      final apiError =
          ApiError(url: path, message: "${e.toString()},\n: $trace", error: e);
      return ApiResponse.error(
          url: path, apiError: apiError, message: errorEncountered);
    }
  }

  /// Handles Dio errors and converts them to [ApiError] instances.
  ///
  /// Parameters:
  /// - [url]: The request URL that generated the error
  /// - [error]: The original Dio error
  ///
  /// Returns an [ApiError] with appropriate error details based on the error type.
  /// Handles timeout, bad response, cancellation and other error cases.
  ApiError _handleDioError(String url, DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return ApiError(
          url: url,
          message: !kDebugMode
              ? 'Connection Error'
              : 'Connection Error[ ${error.message} ]',
          error: error,
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          url: url,
          message: 'Connection timed out',
          statusCode: error.response?.statusCode,
          error: error,
        );
      case DioExceptionType.badResponse:
        return ApiError(
          url: url,
          message: error.response?.statusMessage ?? 'Bad response',
          statusCode: error.response?.statusCode,
          error: error.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiError(
          url: url,
          message: 'Request cancelled',
          statusCode: error.response?.statusCode,
          error: error,
        );
      default:
        return ApiError(
          url: url,
          message: error.message ?? 'Something went wrong',
          statusCode: error.response?.statusCode,
          error: error,
        );
    }
  }

//
}
