import 'filter_criteria.dart';

/// A saved filter configuration that can be applied quickly
class FilterPreset {
  /// Unique identifier for the preset
  final String id;

  /// Display name for the preset
  final String name;

  /// Filter groups in this preset
  final List<FilterGroup> filterGroups;

  /// When the preset was created
  final DateTime createdAt;

  /// When the preset was last modified
  final DateTime updatedAt;

  /// Optional description
  final String? description;

  /// Whether this is a default preset
  final bool isDefault;

  const FilterPreset({
    required this.id,
    required this.name,
    required this.filterGroups,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.isDefault = false,
  });

  /// Create a copy with updated properties
  FilterPreset copyWith({
    String? id,
    String? name,
    List<FilterGroup>? filterGroups,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    bool? isDefault,
  }) {
    return FilterPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      filterGroups: filterGroups ?? this.filterGroups,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! FilterPreset) return false;

    if (other.id != id ||
        other.name != name ||
        other.createdAt != createdAt ||
        other.updatedAt != updatedAt ||
        other.description != description ||
        other.isDefault != isDefault ||
        other.filterGroups.length != filterGroups.length) {
      return false;
    }

    // Compare filter groups manually
    for (var i = 0; i < filterGroups.length; i++) {
      if (other.filterGroups[i] != filterGroups[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    Object.hashAll(filterGroups),
    createdAt,
    updatedAt,
    description,
    isDefault,
  );
}
