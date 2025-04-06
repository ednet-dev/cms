import 'package:meta/meta.dart';

/// Represents an HTTP request in the messaging infrastructure
///
/// In a digital democracy platform, HTTP requests are used for:
/// - Citizen login and authentication
/// - Voter registration submissions
/// - Retrieval of public documents and voting histories
/// - API access to government data
@immutable
class HttpRequest {
  /// The HTTP method used (GET, POST, PUT, DELETE, etc.)
  final String method;

  /// The request path (e.g., '/auth/login')
  final String path;

  /// HTTP headers like Content-Type, Authorization, etc.
  final Map<String, String> headers;

  /// Query parameters from the URL
  final Map<String, String>? queryParameters;

  /// Request body (typically JSON for APIs)
  final String? body;

  /// Creates a new HTTP request
  ///
  /// Example in democratic context:
  /// ```dart
  /// final loginRequest = HttpRequest(
  ///   method: 'POST',
  ///   path: '/auth/login',
  ///   headers: {'Content-Type': 'application/json'},
  ///   body: '{"userId": "citizen123", "password": "secure_pwd"}',
  /// );
  /// ```
  const HttpRequest({
    required this.method,
    required this.path,
    this.headers = const {},
    this.queryParameters,
    this.body,
  });
}

/// Represents an HTTP response in the messaging infrastructure
///
/// In a digital democracy platform, HTTP responses deliver:
/// - Authentication tokens for secure citizen sessions
/// - Confirmation of votes being cast and recorded
/// - Success/failure of democratic participation actions
/// - Results of democratic processes and deliberations
@immutable
class HttpResponse {
  /// HTTP status code (e.g., 200 OK, 404 Not Found)
  final int statusCode;

  /// HTTP headers like Content-Type, Authorization, etc.
  final Map<String, String> headers;

  /// Response body (typically JSON for APIs)
  final String body;

  /// Creates a new HTTP response
  ///
  /// Example in democratic context:
  /// ```dart
  /// final voteConfirmation = HttpResponse(
  ///   statusCode: 201, // Created
  ///   headers: {'Content-Type': 'application/json'},
  ///   body: '{"status": "success", "voteId": "V123456", "recorded": true}',
  /// );
  /// ```
  const HttpResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });
}
