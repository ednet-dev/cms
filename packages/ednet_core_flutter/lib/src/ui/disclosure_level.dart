part of ednet_core_flutter;

/// Represents different levels of information disclosure for UI components.
///
/// DisclosureLevel is used to control how much detail or complexity is shown to the user
/// in UI elements, allowing for progressive disclosure of information based on the user's
/// needs or permissions.
enum DisclosureLevel {
  /// Minimal information, suitable for a first glance or summary view
  minimal,

  /// Basic information that most users would need for common tasks
  basic,

  /// Standard level of detail for regular usage
  standard,

  /// Intermediate level with more details for experienced users
  intermediate,

  /// Advanced level with technical details for power users
  advanced,

  /// Detailed information for users who need more context
  detailed,

  /// Complete information for power users or administrative purposes
  complete,

  /// Debug information only shown in development environments
  debug,
}

/// Extension on DisclosureLevel to provide helper methods
extension DisclosureLevelExtension on DisclosureLevel {
  /// Whether this level is at least as detailed as the provided level
  bool isAtLeast(DisclosureLevel level) {
    return index >= level.index;
  }

  /// Whether this level is exactly the same as the provided level
  bool isExactly(DisclosureLevel level) {
    return index == level.index;
  }

  /// Whether this level is less detailed than the provided level
  bool isLessThan(DisclosureLevel level) {
    return index < level.index;
  }

  /// Get a human-readable name for this disclosure level
  String get displayName {
    switch (this) {
      case DisclosureLevel.minimal:
        return 'Minimal';
      case DisclosureLevel.basic:
        return 'Basic';
      case DisclosureLevel.standard:
        return 'Standard';
      case DisclosureLevel.intermediate:
        return 'Intermediate';
      case DisclosureLevel.advanced:
        return 'Advanced';
      case DisclosureLevel.detailed:
        return 'Detailed';
      case DisclosureLevel.complete:
        return 'Complete';
      case DisclosureLevel.debug:
        return 'Debug';
    }
  }

  /// Get the next higher disclosure level, or the same if already at maximum
  DisclosureLevel get next {
    switch (this) {
      case DisclosureLevel.minimal:
        return DisclosureLevel.basic;
      case DisclosureLevel.basic:
        return DisclosureLevel.standard;
      case DisclosureLevel.standard:
        return DisclosureLevel.intermediate;
      case DisclosureLevel.intermediate:
        return DisclosureLevel.advanced;
      case DisclosureLevel.advanced:
        return DisclosureLevel.detailed;
      case DisclosureLevel.detailed:
        return DisclosureLevel.complete;
      case DisclosureLevel.complete:
        return DisclosureLevel.debug;
      case DisclosureLevel.debug:
        return DisclosureLevel.debug;
    }
  }

  /// Get the previous lower disclosure level, or the same if already at minimum
  DisclosureLevel get previous {
    switch (this) {
      case DisclosureLevel.minimal:
        return DisclosureLevel.minimal;
      case DisclosureLevel.basic:
        return DisclosureLevel.minimal;
      case DisclosureLevel.standard:
        return DisclosureLevel.basic;
      case DisclosureLevel.intermediate:
        return DisclosureLevel.standard;
      case DisclosureLevel.advanced:
        return DisclosureLevel.intermediate;
      case DisclosureLevel.detailed:
        return DisclosureLevel.advanced;
      case DisclosureLevel.complete:
        return DisclosureLevel.detailed;
      case DisclosureLevel.debug:
        return DisclosureLevel.complete;
    }
  }
}
