import 'package:app_http/utils/export.dart'
    show ApiConstants, ApiResponse, ApiError;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ServerService {
  final Dio _dio;
  final bool enableLogging;

  /// Private constructor to prevent direct instantiation
  ServerService._({
    required String baseUrl,
    this.enableLogging = false,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: ApiConstants.connectionTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            validateStatus: (status) => status != null && status < 500,
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
  }

  /// Factory constructor for development environment
  factory ServerService.development({bool enableLogging = false}) {
    return ServerService._(
      baseUrl: ApiConstants.baseUrlDev,
      enableLogging: enableLogging,
    );
  }

  /// Factory constructor for production environment
  factory ServerService.production({bool enableLogging = false}) {
    return ServerService._(
      baseUrl: ApiConstants.baseUrlProd,
      enableLogging: enableLogging,
    );
  }

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: (i, o) {
          debugPrint('** ServerService:get:onReceiveProgress:[$path]: i[ $i ] o[ $o ] *');
        },
      );

      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: (i, o) {
          debugPrint('** ServerService:post:onSendProgress:[$path]: i[ $i ] o[ $o ] *');
        },
        onReceiveProgress: (i, o) {
          debugPrint('** ServerService:post:onReceiveProgress:[$path]: i[ $i ] o[ $o ] *');
        },
      );

      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Generic PATCH request
  Future<ApiResponse<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Generic DELETE request
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

      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Handle Dio errors and convert them to ApiError
  ApiError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Connection timed out',
          statusCode: error.response?.statusCode,
          error: error,
        );
      case DioExceptionType.badResponse:
        return ApiError(
          message: error.response?.statusMessage ?? 'Bad response',
          statusCode: error.response?.statusCode,
          error: error.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiError(
          message: 'Request cancelled',
          statusCode: error.response?.statusCode,
          error: error,
        );
      default:
        return ApiError(
          message: error.message ?? 'Something went wrong',
          statusCode: error.response?.statusCode,
          error: error,
        );
    }
  }

//
}
