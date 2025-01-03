# app_http

A Flutter package that provides a robust HTTP client service built on top of Dio with error handling, logging, and response type safety.

## Features

- Pre-configured HTTP client with timeout settings and base URL management
- Environment-specific configurations (development/production)
- Built-in error handling and standardized API responses
- Optional request/response logging using PrettyDioLogger
- Type-safe API responses
- Support for all standard HTTP methods (GET, POST, PUT, PATCH, DELETE)
- Progress tracking for uploads and downloads
- Configurable timeout settings
- Custom API error handling

## Getting Started

### Installation

Add this package to your project's `pubspec.yaml`:

```yaml
dependencies:
  app_http:
    path: packages/app_http
```

### Basic Usage

```dart
import 'package:app_http/app_http.dart';

// Create an instance for development environment with logging
final serverService = ServerService.development(enableLogging: true);

// Make HTTP requests
try {
  // GET request
  final response = await serverService.get<Map<String, dynamic>>('/users');
  
  // POST request with data
  final createResponse = await serverService.post<Map<String, dynamic>>(
    '/users',
    data: {'name': 'John Doe', 'email': 'john@example.com'},
  );
  
} on ApiError catch (e) {
  print('Error: ${e.message}');
}
```

## API Reference

### ServerService

The main class for making HTTP requests. Provides two factory constructors:

- `ServerService.development()`: Creates an instance configured for development environment
- `ServerService.production()`: Creates an instance configured for production environment

#### Available Methods

- `get<T>(String path)`: Perform GET request
- `post<T>(String path, {dynamic data})`: Perform POST request
- `put<T>(String path, {dynamic data})`: Perform PUT request
- `patch<T>(String path, {dynamic data})`: Perform PATCH request
- `delete<T>(String path, {dynamic data})`: Perform DELETE request

All methods accept optional parameters:
- `queryParameters`: URL query parameters
- `options`: Additional Dio options
- `cancelToken`: Token for cancelling requests

### ApiResponse

A generic class that wraps all API responses:

```dart
class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  
  // Constructor for successful responses
  ApiResponse.success({this.data, this.statusCode});
}
```

### ApiError

Custom error class for handling API errors:

```dart
class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;
  
  ApiError({
    required this.message,
    this.statusCode,
    this.error,
  });
}
```

## Configuration

### Timeouts

Default timeout settings can be modified in `ApiConstants`:

```dart
static const Duration connectionTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
static const Duration sendTimeout = Duration(seconds: 30);
```

### Base URLs

Configure base URLs for different environments in `ApiConstants`:

```dart
static const String baseUrlDev = 'https://api.dev.example.com';
static const String baseUrlProd = 'https://api.example.com';
```

## Error Handling

The package provides comprehensive error handling for various types of network errors:

- Connection timeouts
- Bad responses
- Cancelled requests
- Network errors
- Server errors

Each error is converted to an `ApiError` with appropriate error messages and status codes.

## Logging

Enable detailed request/response logging in development:

```dart
final service = ServerService.development(enableLogging: true);
```

This will log:
- Request headers and body
- Response body
- Error details
- Request/response timing

## License

This project is licensed under the MIT License - see the LICENSE file for details.