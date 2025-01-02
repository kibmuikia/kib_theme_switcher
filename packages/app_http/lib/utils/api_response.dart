class ApiResponse<T> {
  final String? url;
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({
    this.url,
    this.data,
    this.message,
    this.statusCode,
    this.success = true,
  });

  factory ApiResponse.success({
    required String url,
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      url: url,
      data: data,
      message: message,
      statusCode: statusCode,
      success: true,
    );
  }

  factory ApiResponse.error({
    required String url,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      url: url,
      message: message,
      statusCode: statusCode,
      success: false,
    );
  }
}
