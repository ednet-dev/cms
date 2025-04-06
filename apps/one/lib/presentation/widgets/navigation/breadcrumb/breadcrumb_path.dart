import 'package:flutter/foundation.dart';
import 'package:ednet_core/ednet_core.dart';

/// Represents a segment in a breadcrumb navigation path
class BreadcrumbSegment {
  /// Display label for the segment
  final String label;

  /// Type of segment (domain, model, concept, entity)
  final BreadcrumbSegmentType type;

  /// The underlying domain object (if applicable)
  final Domain? domain;

  /// The underlying model object (if applicable)
  final Model? model;

  /// The underlying concept object (if applicable)
  final Concept? concept;

  /// The underlying entity object (if applicable)
  final dynamic entity;

  /// Optional ID for the segment
  final String? id;

  /// Constructor for BreadcrumbSegment
  const BreadcrumbSegment({
    required this.label,
    required this.type,
    this.domain,
    this.model,
    this.concept,
    this.entity,
    this.id,
  });

  /// Get segment from domain
  factory BreadcrumbSegment.fromDomain(Domain domain) {
    return BreadcrumbSegment(
      label: domain.code,
      type: BreadcrumbSegmentType.domain,
      domain: domain,
      id: domain.id.toString(),
    );
  }

  /// Get segment from model
  factory BreadcrumbSegment.fromModel(Model model) {
    return BreadcrumbSegment(
      label: model.code,
      type: BreadcrumbSegmentType.model,
      model: model,
      domain: model.domain,
      id: model.id.toString(),
    );
  }

  /// Get segment from concept
  factory BreadcrumbSegment.fromConcept(Concept concept) {
    return BreadcrumbSegment(
      label: concept.code,
      type: BreadcrumbSegmentType.concept,
      concept: concept,
      model: concept.model,
      domain: concept.model.domain,
      id: concept.id.toString(),
    );
  }

  /// Get segment from entity
  factory BreadcrumbSegment.fromEntity(dynamic entity, String label) {
    Concept? concept;
    try {
      concept = entity.concept;
    } catch (e) {
      debugPrint('Error getting concept from entity: $e');
    }

    return BreadcrumbSegment(
      label: label,
      type: BreadcrumbSegmentType.entity,
      entity: entity,
      concept: concept,
      model: concept?.model,
      domain: concept?.model.domain,
      id: entity.id?.toString(),
    );
  }

  /// Create a path from segments
  static List<BreadcrumbSegment> createPath({
    Domain? domain,
    Model? model,
    Concept? concept,
    dynamic entity,
    String? entityLabel,
  }) {
    final List<BreadcrumbSegment> path = [];

    if (domain != null) {
      path.add(BreadcrumbSegment.fromDomain(domain));
    }

    if (model != null) {
      path.add(BreadcrumbSegment.fromModel(model));
    }

    if (concept != null) {
      path.add(BreadcrumbSegment.fromConcept(concept));
    }

    if (entity != null && entityLabel != null) {
      path.add(BreadcrumbSegment.fromEntity(entity, entityLabel));
    }

    return path;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BreadcrumbSegment && other.type == type && other.id == id;
  }

  @override
  int get hashCode => type.hashCode ^ id.hashCode;
}

/// Types of breadcrumb segments
enum BreadcrumbSegmentType {
  /// Domain level segment
  domain,

  /// Model level segment
  model,

  /// Concept level segment
  concept,

  /// Entity level segment
  entity,

  /// Custom segment (for other navigation types)
  custom,
}
