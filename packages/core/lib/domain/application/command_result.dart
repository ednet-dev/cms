part of ednet_core;

/// Represents the result of a command execution.
///
/// The [CommandResult] class provides:
/// - Status of the command execution (success or failure)
/// - Error message if the command failed
/// - Result data if the command succeeded
/// - Convenience methods for creating success and failure results
///
/// This class is used by application services to communicate the outcome of
/// command executions in a standardized way.
///
/// Example usage:
/// ```dart
/// // Success result with data
/// final result = CommandResult.success(data: createdOrder);
///
/// // Failure result with error message
/// final result = CommandResult.failure("Order creation failed: invalid data");
///
/// // Checking result
/// if (result.isSuccess) {
///   final order = result.data as Order;
///   // Process successful result
/// } else {
///   print("Error: ${result.errorMessage}");
/// }
/// ```
class CommandResult {
  /// Whether the command execution was successful.
  final bool isSuccess;
  
  /// The error message if the command failed.
  final String? errorMessage;
  
  /// The result data if the command succeeded.
  final dynamic data;
  
  /// Creates a new command result.
  ///
  /// Parameters:
  /// - [isSuccess]: Whether the command execution was successful
  /// - [errorMessage]: The error message if the command failed
  /// - [data]: The result data if the command succeeded
  CommandResult({
    required this.isSuccess,
    this.errorMessage,
    this.data,
  });
  
  /// Creates a success result.
  ///
  /// Parameters:
  /// - [data]: Optional result data
  ///
  /// Returns:
  /// A [CommandResult] indicating success
  static CommandResult success({dynamic data}) {
    return CommandResult(
      isSuccess: true,
      data: data,
    );
  }
  
  /// Creates a failure result.
  ///
  /// Parameters:
  /// - [errorMessage]: The error message
  ///
  /// Returns:
  /// A [CommandResult] indicating failure
  static CommandResult failure(String errorMessage) {
    return CommandResult(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
  
  /// Whether the command execution failed.
  bool get isFailure => !isSuccess;
  
  /// Returns a string representation of this result.
  @override
  String toString() {
    if (isSuccess) {
      return 'CommandResult.success(data: $data)';
    } else {
      return 'CommandResult.failure(errorMessage: $errorMessage)';
    }
  }
} 