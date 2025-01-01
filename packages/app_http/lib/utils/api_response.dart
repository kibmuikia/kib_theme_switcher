class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({
    this.data,
    this.message,
    this.statusCode,
    this.success = true,
  });

  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      data: data,
      message: message,
      statusCode: statusCode,
      success: true,
    );
  }

  factory ApiResponse.error({
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      message: message,
      statusCode: statusCode,
      success: false,
    );
  }
}
