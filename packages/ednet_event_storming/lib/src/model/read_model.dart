import 'package:ednet_core/ednet_core.dart';
import 'domain_event.dart';
import 'element.dart';

/// Represents a read model in an Event Storming session.
///
/// In Event Storming, read models represent views or projections of the domain
/// that are used for querying data. They are typically represented by
/// green sticky notes on the event storming board.
class EventStormingReadModel extends EventStormingElement {
  /// IDs of domain events that update this read model.
  final List<String> updatedByEventIds;

  /// The properties or fields of this read model.
  final Map<String, String> fields;

  /// Creates a new read model.
  EventStormingReadModel({
    required String id,
    required String name,
    String description = '',
    List<String> tags = const [],
    required Position position,
    this.updatedByEventIds = const [],
    this.fields = const {},
    required String createdBy,
    required DateTime createdAt,
    String color = '#90EE90', // Light green by default
  }) : super(
          id: id,
          name: name,
          description: description,
          tags: tags,
          position: position,
          createdBy: createdBy,
          createdAt: createdAt,
          color: color,
        );

  /// Creates a read model from a map representation.
  factory EventStormingReadModel.fromJson(Map<String, dynamic> json) {
    return EventStormingReadModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      updatedByEventIds: (json['updatedByEventIds'] as List<dynamic>?)?.cast<String>() ?? [],
      fields: (json['fields'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          {},
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#90EE90',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'position': position.toJson(),
      'updatedByEventIds': updatedByEventIds,
      'fields': fields,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'elementType': elementType,
    };
  }

  @override
  EventStormingReadModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    List<String>? updatedByEventIds,
    Map<String, String>? fields,
    String? createdBy,
    DateTime? createdAt,
    String? color,
  }) {
    return EventStormingReadModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      updatedByEventIds: updatedByEventIds ?? this.updatedByEventIds,
      fields: fields ?? this.fields,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
    );
  }

  /// Adds an event that updates this read model.
  EventStormingReadModel addUpdatedByEvent(String eventId) {
    if (updatedByEventIds.contains(eventId)) {
      return this;
    }
    return copyWith(
      updatedByEventIds: [...updatedByEventIds, eventId],
    );
  }

  /// Removes an event that updates this read model.
  EventStormingReadModel removeUpdatedByEvent(String eventId) {
    return copyWith(
      updatedByEventIds: updatedByEventIds.where((id) => id != eventId).toList(),
    );
  }

  /// Adds a field to this read model.
  EventStormingReadModel addField(String name, String type) {
    return copyWith(
      fields: {...fields, name: type},
    );
  }

  /// Removes a field from this read model.
  EventStormingReadModel removeField(String name) {
    final newFields = Map<String, String>.from(fields);
    newFields.remove(name);
    return copyWith(
      fields: newFields,
    );
  }

  /// Converts this event storming read model to an EDNet Core concept.
  model.Concept toCoreConcept() {
    final concept = model.Concept(
      name: name,
      code: name.toLowerCase().replaceAll(' ', '_'),
      description: description,
    );

    // Add attributes for each field
    fields.forEach((fieldName, fieldType) {
      concept.attributes.add(
        model.Attribute(
          concept: concept,
          name: fieldName,
          code: fieldName.toLowerCase(),
          type: fieldType,
        ),
      );
    });

    return concept;
  }
  
  @override
  ednet_core.model.Entity toCoreModelEntity() {
    // Read models would likely be represented as Concepts in EDNet Core
    return toCoreConcept();
  }
  
  @override
  String get elementType => 'read_model';
} 