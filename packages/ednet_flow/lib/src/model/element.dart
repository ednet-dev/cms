// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:ednet_core/ednet_core.dart';




/// Base class for all Event Storming elements.
///
/// This class provides common properties and behaviors for all
/// elements that can be placed on an Event Storming board.
abstract class EventStormingElement {
  /// The unique identifier for this element.
  final String id;

  /// The name of this element.
  final String name;

  /// A more detailed description of this element.
  final String description;

  /// Tags or categories to help organize and filter elements.
  final List<String> tags;

  /// The position of this element on the event storming board.
  final Position position;

  /// Who created this element during the storming session.
  final String createdBy;

  /// When this element was added to the board.
  final DateTime createdAt;

  /// The color used to represent this element on the board.
  final String color;

  /// Creates a new Event Storming element.
  EventStormingElement({
    required this.id,
    required this.name,
    this.description = '',
    this.tags = const [],
    required this.position,
    required this.createdBy,
    required this.createdAt,
    required this.color,
  });

  /// Converts this element to a map representation.
  Map<String, dynamic> toJson();

  /// Creates a copy of this element with the given fields replaced with new values.
  EventStormingElement copyWith();

  /// Converts this Event Storming element to an EDNet Core model entity.
  ednet_core.model.Entity toCoreModelEntity() {
    // Default implementation that can be overridden by specific element types
    final entity = ednet_core.model.Entity(
      name: name,
      // No constructor available that matches this in EDNet Core
    );
    
    // Add basic properties
    // Since there's no direct way to add attributes in the constructor,
    // this would need to be handled differently in actual implementations
    
    return entity;
  }
  
  /// Type of this element (event, command, aggregate, etc.)
  String get elementType;
}

/// Represents a connection between Event Storming elements.
class ElementConnection {
  /// Source element ID of the connection.
  final String sourceId;
  
  /// Target element ID of the connection.
  final String targetId;
  
  /// Type of connection between elements.
  final ConnectionType type;
  
  /// Creates a new connection between elements.
  ElementConnection({
    required this.sourceId,
    required this.targetId,
    required this.type,
  });
  
  /// Creates a connection from a map representation.
  factory ElementConnection.fromJson(Map<String, dynamic> json) {
    return ElementConnection(
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      type: ConnectionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ConnectionType.RELATES_TO,
      ),
    );
  }
  
  /// Converts this connection to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'targetId': targetId,
      'type': type.toString().split('.').last,
    };
  }
}

/// Defines the type of connection between Event Storming elements.
enum ConnectionType {
  /// A command triggers an event
  TRIGGERS,
  
  /// An aggregate handles a command
  HANDLES,
  
  /// An aggregate produces an event
  PRODUCES,
  
  /// A policy issues a command
  ISSUES,
  
  /// A role initiates a command
  INITIATES,
  
  /// An event updates a read model
  UPDATES,
  
  /// Generic relation between elements
  RELATES_TO,
} 