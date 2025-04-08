part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Status of a response
enum ResponseStatus {
  /// Operation completed successfully
  success,

  /// Operation failed due to an error
  error,

  /// Operation is in progress
  loading,

  /// Operation requires additional information
  moreInfoNeeded,

  /// Operation was cancelled
  cancelled,

  /// Operation is not authorized
  unauthorized,

  /// Resource not found
  notFound,
}

/// Standard response format for operations within the application
///
/// This provides a consistent way to handle responses across the application,
/// whether they are API responses, operation results, or user interactions.
class ResponseUtils<T> {
  /// Status of the response
  final ResponseStatus status;

  /// Response data
  final T? data;

  /// Error message, if any
  final String? message;

  /// Error code, if any
  final String? code;

  /// Timestamp of the response
  final DateTime timestamp;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Creates a standard response
  ResponseUtils({
    required this.status,
    this.data,
    this.message,
    this.code,
    Map<String, dynamic>? metadata,
  })  : timestamp = DateTime.now(),
        metadata = metadata;

  /// Creates a successful response
  factory ResponseUtils.success({
    T? data,
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseUtils<T>(
      status: ResponseStatus.success,
      data: data,
      message: message,
      metadata: metadata,
    );
  }

  /// Creates an error response
  factory ResponseUtils.error({
    String? message,
    String? code,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseUtils<T>(
      status: ResponseStatus.error,
      message: message,
      code: code,
      metadata: metadata,
    );
  }

  /// Creates a loading response
  factory ResponseUtils.loading({
    T? data,
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseUtils<T>(
      status: ResponseStatus.loading,
      data: data,
      message: message,
      metadata: metadata,
    );
  }

  /// Creates a not found response
  factory ResponseUtils.notFound({
    String? message,
    String? code,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseUtils<T>(
      status: ResponseStatus.notFound,
      message: message ?? 'Resource not found',
      code: code,
      metadata: metadata,
    );
  }

  /// Creates an unauthorized response
  factory ResponseUtils.unauthorized({
    String? message,
    String? code,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseUtils<T>(
      status: ResponseStatus.unauthorized,
      message: message ?? 'Unauthorized access',
      code: code,
      metadata: metadata,
    );
  }

  /// Returns true if the response was successful
  bool get isSuccess => status == ResponseStatus.success;

  /// Returns true if the response was an error
  bool get isError => status == ResponseStatus.error;

  /// Returns true if the response is loading
  bool get isLoading => status == ResponseStatus.loading;

  /// Returns true if the resource was not found
  bool get isNotFound => status == ResponseStatus.notFound;

  /// Returns true if the request was unauthorized
  bool get isUnauthorized => status == ResponseStatus.unauthorized;

  /// Converts the response to a map
  Map<String, dynamic> toMap() {
    return {
      'status': status.toString(),
      'data': data,
      'message': message,
      'code': code,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'Response{status: $status, message: $message, data: $data}';
  }
}
