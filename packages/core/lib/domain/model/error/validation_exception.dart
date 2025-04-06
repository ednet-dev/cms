part of ednet_core;

/// Represents a domain validation exception in the EDNet Core framework.
///
/// The [ValidationException] class provides a structured way to report
/// validation errors from the domain layer, including:
/// - A category to classify the type of validation error
/// - A detailed message explaining the error
/// - Integration with the application layer exception handling
///
/// This class implements [Exception] to enable standard try/catch handling,
/// and is used throughout the domain model to report validation failures.
///
/// Example usage:
/// ```dart
/// throw ValidationException('required', 'The name field is required');
/// ```
class ValidationException implements Exception, IValidationExceptions {
  /// The category of the validation error (e.g., 'required', 'format', 'domain rule').
  final String category;

  /// A descriptive message explaining the validation error.
  final String message;

  /// The entity that caused the validation error, if any.
  final Entity? entity;

  /// The attribute that failed validation, if applicable.
  final String? attribute;

  /// Creates a new validation exception.
  ///
  /// [category] is the type of validation error.
  /// [message] is a descriptive explanation of the error.
  /// [entity] is the optional entity that failed validation.
  /// [attribute] is the optional attribute that failed validation.
  ValidationException(
    this.category,
    this.message, {
    this.entity,
    this.attribute,
  }) {
    if (logExceptions) {
      print('VALIDATION EXCEPTION: $category - $message');
    }
  }

  /// Whether to log exceptions to the console.
  /// This can be useful for debugging, but might be turned off in production.
  static bool logExceptions = true;

  /// Implementation of IValidationExceptions interface
  @override
  int get length => 1;

  @override
  void add(IValidationExceptions exception) {
    /// Single exception can't add other exceptions
    throw UnsupportedError(
      "Can't add exceptions to a ValidationException instance",
    );
  }

  @override
  void clear() {
    /// Single exception can't be cleared
    throw UnsupportedError("Can't clear a ValidationException instance");
  }

  @override
  List<IValidationExceptions> toList() => [this];

  /// Returns a string that represents the error.
  @override
  String toString() {
    if (attribute != null) {
      return '$category: $message (attribute: $attribute)';
    }
    return '$category: $message';
  }

  /// Displays (prints) an exception.
  ///
  /// This method formats and prints details about the exception,
  /// which can be useful for debugging.
  ///
  /// [prefix] is an optional prefix to add to each line of output.
  void display({String prefix = ''}) {
    print('$prefix******************************************');
    print('$prefix$category                               ');
    print('$prefix******************************************');
    print('${prefix}message: $message');
    if (attribute != null) {
      print('${prefix}attribute: $attribute');
    }
    if (entity != null) {
      print('${prefix}entity: ${entity.toString()}');
    }
    print('$prefix******************************************');
    print('');
  }

  /// Converts this exception to an error result for the application layer.
  ///
  /// This method facilitates error reporting to the application layer in
  /// a standardized format that can be used by application services.
  ///
  /// Returns a map with error details.
  Map<String, dynamic> toErrorResult() {
    final result = <String, dynamic>{'category': category, 'message': message};

    if (attribute != null) {
      result['attribute'] = attribute;
    }

    if (entity != null) {
      result['entityType'] = entity?.concept.code;
      result['entityId'] = entity?.id?.toString();
    }

    return result;
  }

  /// Creates a validation exception from an error result.
  ///
  /// This static method creates a validation exception from an error result
  /// that originated in the application layer, enabling bidirectional
  /// conversion between the layers.
  ///
  /// [errorResult] is the error result to convert.
  /// Returns a new [ValidationException].
  static ValidationException fromErrorResult(Map<String, dynamic> errorResult) {
    return ValidationException(
      errorResult['category'] as String,
      errorResult['message'] as String,
      attribute: errorResult['attribute'] as String?,
    );
  }
}
