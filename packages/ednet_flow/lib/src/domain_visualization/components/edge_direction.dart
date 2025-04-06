// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';



/// Defines the direction of an edge in a domain model graph.
///
/// Edge directions specify how relationships flow between nodes, which is
/// crucial for understanding the domain model structure and navigability.
enum EdgeDirection {
  /// Edge flows from left to right.
  leftToRight,

  /// Edge flows from right to left.
  rightToLeft,

  /// Edge flows in both directions.
  bidirectional,

  /// Edge has no specific direction.
  none;

  /// Returns a user-friendly string representation of this edge direction.
  String get displayName {
    switch (this) {
      case EdgeDirection.leftToRight:
        return 'Left to Right';
      case EdgeDirection.rightToLeft:
        return 'Right to Left';
      case EdgeDirection.bidirectional:
        return 'Bidirectional';
      case EdgeDirection.none:
        return 'No Direction';
    }
  }

  /// Creates an EdgeDirection from a string representation.
  static EdgeDirection fromString(String value) {
    final lowerValue = value.toLowerCase();

    // Handle full enum paths (e.g., "EdgeDirection.leftToRight")
    final parts = lowerValue.split('.');
    final name = parts.length > 1 ? parts[1] : lowerValue;

    return EdgeDirection.values.firstWhere(
      (direction) => direction.toString().split('.').last == name,
      orElse: () => EdgeDirection.leftToRight,
    );
  }

  /// Determines if this direction indicates the edge can be traversed
  /// from source to target.
  bool get isForward =>
      this == EdgeDirection.leftToRight || this == EdgeDirection.bidirectional;

  /// Determines if this direction indicates the edge can be traversed
  /// from target to source.
  bool get isBackward =>
      this == EdgeDirection.rightToLeft || this == EdgeDirection.bidirectional;
}
