class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiError({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() =>
      'ApiError(message: $message, statusCode: $statusCode, error: $error)';
}
