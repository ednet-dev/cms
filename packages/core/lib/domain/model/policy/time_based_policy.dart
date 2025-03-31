part of ednet_core;

/// A policy that validates time-based conditions on entity attributes.
///
/// The [TimeBasedPolicy] class implements [IPolicy] to provide validation
/// for time-based conditions. It can validate:
/// - Whether a time attribute is before/after a certain duration
/// - Whether a time attribute falls within a specific time range
/// - Whether a time attribute is within a recent or upcoming period
///
/// Example usage:
/// ```dart
/// final expiryPolicy = TimeBasedPolicy(
///   name: 'ExpiryPolicy',
///   description: 'Product must not be expired',
///   timeAttributeName: 'expiryDate',
///   validator: TimeValidators.isBefore(Duration(days: 30)),
/// );
///
/// final upcomingPolicy = TimeBasedPolicy(
///   name: 'UpcomingPolicy',
///   description: 'Event must be in the future',
///   timeAttributeName: 'eventDate',
///   validator: TimeValidators.isAfter(Duration(days: 0)),
/// );
/// ```
class TimeBasedPolicy implements IPolicy {
  @override
  final String name;
  @override
  final String description;
  /// The name of the attribute containing the time value to validate.
  final String timeAttributeName;
  /// The function that validates the time value.
  final TimeValidator validator;
  /// The clock used to get the current time.
  final Clock clock;
  @override
  final PolicyScope? scope;

  /// Creates a new [TimeBasedPolicy] instance.
  ///
  /// [name] is the unique name of the policy.
  /// [description] is a human-readable description of what the policy enforces.
  /// [timeAttributeName] is the name of the attribute containing the time value.
  /// [validator] is the function that validates the time value.
  /// [scope] is the scope at which the policy should be evaluated.
  /// [clock] is the clock to use for getting the current time.
  TimeBasedPolicy({
    required this.name,
    required this.description,
    required this.timeAttributeName,
    required this.validator,
    this.scope,
    Clock? clock,
  }) : clock = clock ?? SystemClock();

  /// Evaluates the time-based condition for the given entity.
  ///
  /// [entity] is the entity to evaluate.
  /// Returns true if the time condition is satisfied, false otherwise.
  bool _evaluateTime(Entity entity) {
    var timeAttribute = entity.getAttribute(timeAttributeName);
    if (timeAttribute == null || timeAttribute is! DateTime) {
      print(
          'Time-based policy violation: Attribute "$timeAttributeName" is missing or not a DateTime.');
      return false;
    }
    return validator(timeAttribute, clock.now());
  }

  @override
  bool evaluate(Entity entity) {
    if (scope == null) {
      return _evaluateTime(entity);
    }
    if (!scope!.isWithinScope(entity)) {
      return true; // Skip entities not within scope
    }
    return _evaluateTime(entity);
  }

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    if (scope == null) {
      bool result = _evaluateTime(entity);
      if (result) {
        return PolicyEvaluationResult(true, []);
      } else {
        var currentTime = clock.now();
        var timeAttribute = entity.getAttribute(timeAttributeName);
        log(entity, timeAttribute, currentTime);
      }
      return policyEvaluationResult;
    }

    if (!scope!.isWithinScope(entity)) {
      return PolicyEvaluationResult(true, []); // Skip entities not within scope
    }

    bool result = _evaluateTime(entity);
    if (result) {
      return PolicyEvaluationResult(true, []);
    } else {
      var currentTime = clock.now();
      var timeAttribute = entity.getAttribute(timeAttributeName);
      log(entity, timeAttribute, currentTime);
      return policyEvaluationResult;
    }
  }

  /// Gets the evaluation result for a policy violation.
  PolicyEvaluationResult get policyEvaluationResult {
    return PolicyEvaluationResult(false,
        [PolicyViolation(name, 'Time-based policy violation: $description')]);
  }

  /// Logs details about a policy violation.
  ///
  /// [entity] is the entity that violated the policy.
  /// [timeAttribute] is the time value that caused the violation.
  /// [currentTime] is the current time when the violation occurred.
  void log(
      Entity<Entity<dynamic>> entity, timeAttribute, DateTime currentTime) {
    print('Time-based policy violation: $description. '
        'Entity: ${entity.toString()}, '
        'Attribute: $timeAttributeName, '
        'Attribute Value: $timeAttribute, '
        'Current Time: $currentTime');
  }
}

/// A function type for validating time-based conditions.
///
/// [attributeTime] is the time value from the entity's attribute.
/// [currentTime] is the current time.
/// Returns true if the time condition is satisfied, false otherwise.
typedef TimeValidator = bool Function(
    DateTime attributeTime, DateTime currentTime);

/// Provides common time-based validation functions.
///
/// The [TimeValidators] class contains static functions for common
/// time-based validation scenarios. These can be used with [TimeBasedPolicy]
/// to create policies for common time-based constraints.
///
/// Example usage:
/// ```dart
/// // Check if a time is before a certain duration ago
/// final isExpired = TimeValidators.isBefore(Duration(days: 30));
///
/// // Check if a time is after a certain duration in the future
/// final isUpcoming = TimeValidators.isAfter(Duration(days: 7));
///
/// // Check if a time is within a specific range
/// final isInSeason = TimeValidators.isBetween(
///   DateTime(2024, 6, 1),
///   DateTime(2024, 8, 31),
/// );
///
/// // Check if a time is within the last duration
/// final isRecent = TimeValidators.isWithinLast(Duration(hours: 24));
///
/// // Check if a time is within the next duration
/// final isSoon = TimeValidators.isWithinNext(Duration(days: 7));
/// ```
class TimeValidators {
  /// Creates a validator that checks if a time is before a certain duration ago.
  ///
  /// [duration] is the duration to check against.
  /// Returns a validator that checks if the attribute time is before (current time - duration).
  static TimeValidator isBefore(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isBefore(currentTime.subtract(duration));
  }

  /// Creates a validator that checks if a time is after a certain duration in the future.
  ///
  /// [duration] is the duration to check against.
  /// Returns a validator that checks if the attribute time is after (current time + duration).
  static TimeValidator isAfter(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isAfter(currentTime.add(duration));
  }

  /// Creates a validator that checks if a time is within a specific range.
  ///
  /// [start] is the start of the valid time range.
  /// [end] is the end of the valid time range.
  /// Returns a validator that checks if the attribute time is between [start] and [end].
  static TimeValidator isBetween(DateTime start, DateTime end) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isAfter(start) && attributeTime.isBefore(end);
  }

  /// Creates a validator that checks if a time is within the last duration.
  ///
  /// [duration] is the duration to check against.
  /// Returns a validator that checks if the attribute time is after (current time - duration).
  static TimeValidator isWithinLast(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isAfter(currentTime.subtract(duration));
  }

  /// Creates a validator that checks if a time is within the next duration.
  ///
  /// [duration] is the duration to check against.
  /// Returns a validator that checks if the attribute time is before (current time + duration).
  static TimeValidator isWithinNext(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isBefore(currentTime.add(duration));
  }
}

/// A concrete implementation of [Clock] that uses the system time.
class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}

/// An abstract class for getting the current time.
///
/// This class allows for dependency injection of time sources,
/// making it easier to test time-based policies.
abstract class Clock {
  /// Gets the current time.
  DateTime now();
}
