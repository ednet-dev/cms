import 'package:meta/meta.dart';

/// Represents an HTTP request in the patterns library
///
/// Used by channel adapters to abstract HTTP communication.
@immutable
class HttpRequest {
  /// HTTP method (GET, POST, PUT, DELETE, etc.)
  final String method;

  /// Request path (excluding query parameters)
  final String path;

  /// HTTP request headers
  final Map<String, String> headers;

  /// Query parameters
  final Map<String, String>? queryParameters;

  /// Request body
  final String? body;

  /// Creates a new HTTP request
  const HttpRequest({
    required this.method,
    required this.path,
    this.headers = const {},
    this.queryParameters,
    this.body,
  });

  /// Creates a copy with modified properties
  HttpRequest copyWith({
    String? method,
    String? path,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    String? body,
  }) {
    return HttpRequest(
      method: method ?? this.method,
      path: path ?? this.path,
      headers: headers ?? Map.from(this.headers),
      queryParameters: queryParameters ?? this.queryParameters,
      body: body ?? this.body,
    );
  }

  @override
  String toString() {
    return 'HttpRequest{method: $method, path: $path, headers: $headers, queryParameters: $queryParameters}';
  }
}

/// Represents an HTTP response in the patterns library
///
/// Used by channel adapters to abstract HTTP communication.
@immutable
class HttpResponse {
  /// HTTP status code
  final int statusCode;

  /// Response headers
  final Map<String, String> headers;

  /// Response body
  final String body;

  /// Creates a new HTTP response
  const HttpResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  /// Creates a copy with modified properties
  HttpResponse copyWith({
    int? statusCode,
    Map<String, String>? headers,
    String? body,
  }) {
    return HttpResponse(
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? Map.from(this.headers),
      body: body ?? this.body,
    );
  }

  @override
  String toString() {
    return 'HttpResponse{statusCode: $statusCode, headers: $headers}';
  }
}
