part of ednet_core;

/// Represents a value object in Domain-Driven Design.
///
/// The [ValueObject] class represents a descriptive aspect of the domain:
/// - Is immutable
/// - Has no identity
/// - Is defined by its attributes
/// - Is equality-comparable by value, not reference
///
/// Value objects are used to:
/// - Encapsulate business rules
/// - Represent concepts that have no continuity or identity
/// - Ensure data validity and consistency
///
/// Example usage:
/// ```dart
/// class Money extends ValueObject {
///   final Decimal amount;
///   final String currency;
///
///   Money({required this.amount, required this.currency}) {
///     validate();
///   }
///
///   @override
///   void validate() {
///     if (amount < Decimal.zero) {
///       throw ValidationException("Amount cannot be negative");
///     }
///     if (currency.isEmpty) {
///       throw ValidationException("Currency cannot be empty");
///     }
///   }
///
///   Money add(Money other) {
///     if (currency != other.currency) {
///       throw InvalidOperationException("Cannot add different currencies");
///     }
///     return Money(amount: amount + other.amount, currency: currency);
///   }
///
///   @override
///   List<Object> get props => [amount, currency];
/// }
/// ```
abstract class ValueObject {
  /// The list of properties that define this value object.
  ///
  /// This is used for equality comparison and hash code generation.
  List<Object> get props;

  /// Validates this value object.
  ///
  /// This method should:
  /// - Ensure all properties are valid
  /// - Enforce business rules
  /// - Throw exceptions for invalid states
  void validate() {
    // Default implementation, subclasses should override
  }

  /// Compares this value object with another value object.
  ///
  /// Parameters:
  /// - [other]: The object to compare with
  ///
  /// Returns:
  /// True if the objects are equal, false otherwise
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return _compareProps(other as ValueObject);
  }

  /// Compares the properties of this value object with another.
  ///
  /// Parameters:
  /// - [other]: The value object to compare with
  ///
  /// Returns:
  /// True if all properties are equal, false otherwise
  bool _compareProps(ValueObject other) {
    if (props.length != other.props.length) return false;
    for (var i = 0; i < props.length; i++) {
      if (props[i] != other.props[i]) return false;
    }
    return true;
  }

  /// Generates a hash code for this value object based on its properties.
  ///
  /// Returns:
  /// A hash code derived from the object's properties
  @override
  int get hashCode => Object.hashAll(props);

  /// Copies this value object with new property values.
  ///
  /// This method should be implemented by subclasses to provide
  /// a way to create a new value object with modified properties.
  ValueObject copyWith();

  /// Returns a string representation of this value object.
  ///
  /// Returns:
  /// A string representation including the class name and properties
  @override
  String toString() {
    return '$runtimeType(${props.map((prop) => prop.toString()).join(', ')})';
  }
} 