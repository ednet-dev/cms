import 'domain_event.dart';

/// Represents a hot spot in an Event Storming session.
///
/// In Event Storming, hot spots identify areas of confusion, disagreement,
/// or complexity in the domain. They are typically represented by
/// red sticky notes on the event storming board.
class EventStormingHotSpot {
  /// The unique identifier for this hot spot.
  final String id;

  /// The title of this hot spot (e.g., "Unclear Payment Process").
  final String title;

  /// A more detailed description of what this hot spot represents.
  final String description;

  /// Tags or categories to help organize and filter hot spots.
  final List<String> tags;

  /// The position of this hot spot on the event storming board.
  final Position position;

  /// The importance level of this hot spot (1-5).
  final int importance;

  /// IDs of elements (e.g., events, commands) related to this hot spot.
  final List<String> relatedElementIds;

  /// Who created this hot spot during the storming session.
  final String createdBy;

  /// When this hot spot was added to the board.
  final DateTime createdAt;

  /// The color used to represent this hot spot on the board (red by default).
  final String color;

  /// Proposed solutions for addressing this hot spot.
  final List<String> proposedSolutions;

  /// Creates a new hot spot.
  EventStormingHotSpot({
    required this.id,
    required this.title,
    this.description = '',
    this.tags = const [],
    required this.position,
    this.importance = 3,
    this.relatedElementIds = const [],
    required this.createdBy,
    required this.createdAt,
    this.color = '#FF0000', // Red by default
    this.proposedSolutions = const [],
  });

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

  /// Converts this hot spot to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
      'position': position.toJson(),
      'importance': importance,
      'relatedElementIds': relatedElementIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'proposedSolutions': proposedSolutions,
    };
  }

  /// Creates a copy of this hot spot with the given fields replaced with new values.
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
} 