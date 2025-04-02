import 'domain_event.dart';
import 'element.dart';

/// Represents a hot spot in an Event Storming session.
///
/// In Event Storming, hot spots identify areas of confusion, disagreement,
/// or complexity in the domain. They are typically represented by
/// red sticky notes on the event storming board.
class EventStormingHotSpot extends EventStormingElement {
  /// The title of this hot spot (e.g., "Unclear Payment Process").
  final String title;
  
  /// The importance level of this hot spot (1-5).
  final int importance;

  /// IDs of elements (e.g., events, commands) related to this hot spot.
  final List<String> relatedElementIds;

  /// Proposed solutions for addressing this hot spot.
  final List<String> proposedSolutions;

  /// Creates a new hot spot.
  EventStormingHotSpot({
    required String id,
    required this.title,
    String description = '',
    List<String> tags = const [],
    required Position position,
    this.importance = 3,
    this.relatedElementIds = const [],
    required String createdBy,
    required DateTime createdAt,
    String color = '#FF0000', // Red by default
    this.proposedSolutions = const [],
  }) : super(
          id: id,
          name: title, // Use title as the name for the base class
          description: description,
          tags: tags,
          position: position,
          createdBy: createdBy,
          createdAt: createdAt,
          color: color,
        );

  /// Creates a hot spot from a map representation.
  factory EventStormingHotSpot.fromJson(Map<String, dynamic> json) {
    return EventStormingHotSpot(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      importance: json['importance'] as int? ?? 3,
      relatedElementIds: (json['relatedElementIds'] as List<dynamic>?)?.cast<String>() ?? [],
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#FF0000',
      proposedSolutions: (json['proposedSolutions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'description': description,
      'tags': tags,
      'position': position.toJson(),
      'importance': importance,
      'relatedElementIds': relatedElementIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'proposedSolutions': proposedSolutions,
      'elementType': elementType,
    };
  }

  @override
  EventStormingHotSpot copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? tags,
    Position? position,
    int? importance,
    List<String>? relatedElementIds,
    String? createdBy,
    DateTime? createdAt,
    String? color,
    List<String>? proposedSolutions,
  }) {
    return EventStormingHotSpot(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      importance: importance ?? this.importance,
      relatedElementIds: relatedElementIds ?? this.relatedElementIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      proposedSolutions: proposedSolutions ?? this.proposedSolutions,
    );
  }

  /// Adds a related element to this hot spot.
  EventStormingHotSpot addRelatedElement(String elementId) {
    if (relatedElementIds.contains(elementId)) {
      return this;
    }
    return copyWith(
      relatedElementIds: [...relatedElementIds, elementId],
    );
  }

  /// Removes a related element from this hot spot.
  EventStormingHotSpot removeRelatedElement(String elementId) {
    return copyWith(
      relatedElementIds: relatedElementIds.where((id) => id != elementId).toList(),
    );
  }

  /// Adds a proposed solution to this hot spot.
  EventStormingHotSpot addProposedSolution(String solution) {
    if (proposedSolutions.contains(solution)) {
      return this;
    }
    return copyWith(
      proposedSolutions: [...proposedSolutions, solution],
    );
  }

  /// Removes a proposed solution from this hot spot.
  EventStormingHotSpot removeProposedSolution(String solution) {
    return copyWith(
      proposedSolutions: proposedSolutions.where((s) => s != solution).toList(),
    );
  }
  
  @override
  ednet_core.model.Entity toCoreModelEntity() {
    // Hot spots might not have a direct parallel in the EDNet Core model
    // So we'll create a custom representation
    final entity = ednet_core.model.Entity(
      name: title,
    );
    return entity;
  }
  
  @override
  String get elementType => 'hotspot';
} 