// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;





enum EdgeType {
  /// A basic association between entities.
  association,

  /// A composition relationship (strong ownership, lifecycle dependency).
  composition,

  /// An aggregation relationship (weak ownership, independent lifecycle).
  aggregation,

  /// An inheritance relationship between entities.
  inheritance,

  /// An implementation relationship (e.g., interface implementation).
  implementation,

  /// A dependency relationship between entities.
  dependency,

  /// A causation relationship (e.g., event triggers command).
  causation;

  /// Returns a user-friendly string representation of this edge type.
  String get displayName {
    switch (this) {
      case EdgeType.association:
        return 'Association';
      case EdgeType.composition:
        return 'Composition';
      case EdgeType.aggregation:
        return 'Aggregation';
      case EdgeType.inheritance:
        return 'Inheritance';
      case EdgeType.implementation:
        return 'Implementation';
      case EdgeType.dependency:
        return 'Dependency';
      case EdgeType.causation:
        return 'Causation';
    }
  }

  /// Creates an EdgeType from a string representation.
  static EdgeType fromString(String value) {
    final lowerValue = value.toLowerCase();

    // Handle full enum paths (e.g., "EdgeType.association")
    final parts = lowerValue.split('.');
    final name = parts.length > 1 ? parts[1] : lowerValue;

    return EdgeType.values.firstWhere(
      (type) => type.toString().split('.').last == name,
      orElse: () => EdgeType.association,
    );
  }

  /// Gets the appropriate line dash pattern for this edge type
  List<double>? get dashPattern {
    switch (this) {
      case EdgeType.dependency:
      case EdgeType.implementation:
        return [5, 5]; // Dashed line
      case EdgeType.association:
      case EdgeType.composition:
      case EdgeType.aggregation:
      case EdgeType.inheritance:
      case EdgeType.causation:
        return null; // Solid line
    }
  }

  /// Gets an appropriate marker for the start of an edge
  String? get startMarker {
    switch (this) {
      case EdgeType.composition:
        return 'diamond-filled';
      case EdgeType.aggregation:
        return 'diamond-outline';
      case EdgeType.inheritance:
      case EdgeType.implementation:
      case EdgeType.association:
      case EdgeType.dependency:
      case EdgeType.causation:
        return null;
    }
  }

  /// Gets an appropriate marker for the end of an edge
  String? get endMarker {
    switch (this) {
      case EdgeType.inheritance:
      case EdgeType.implementation:
        return 'triangle';
      case EdgeType.association:
      case EdgeType.dependency:
      case EdgeType.causation:
        return 'arrow';
      case EdgeType.composition:
      case EdgeType.aggregation:
        return null;
    }
  }
}
