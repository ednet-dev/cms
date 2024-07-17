part of ednet_core;

class TimeBasedPolicy implements IPolicy {
  @override
  final String name;
  @override
  final String description;
  final String timeAttributeName;
  final TimeValidator validator;
  final Clock clock;
  @override
  final PolicyScope? scope;

  TimeBasedPolicy({
    required this.name,
    required this.description,
    required this.timeAttributeName,
    required this.validator,
    this.scope,
    Clock? clock,
  }) : clock = clock ?? SystemClock();

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

  PolicyEvaluationResult get policyEvaluationResult {
    return PolicyEvaluationResult(false,
        [PolicyViolation(name, 'Time-based policy violation: $description')]);
  }

  void log(
      Entity<Entity<dynamic>> entity, timeAttribute, DateTime currentTime) {
    print('Time-based policy violation: $description. '
        'Entity: ${entity.toString()}, '
        'Attribute: $timeAttributeName, '
        'Attribute Value: $timeAttribute, '
        'Current Time: $currentTime');
  }
}

typedef TimeValidator = bool Function(
    DateTime attributeTime, DateTime currentTime);

class TimeValidators {
  static TimeValidator isBefore(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isBefore(currentTime.subtract(duration));
  }

  static TimeValidator isAfter(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isAfter(currentTime.add(duration));
  }

  static TimeValidator isBetween(DateTime start, DateTime end) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isAfter(start) && attributeTime.isBefore(end);
  }

  static TimeValidator isWithinLast(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isAfter(currentTime.subtract(duration));
  }

  static TimeValidator isWithinNext(Duration duration) {
    return (DateTime attributeTime, DateTime currentTime) =>
        attributeTime.isBefore(currentTime.add(duration));
  }
}

class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}

abstract class Clock {
  DateTime now();
}
