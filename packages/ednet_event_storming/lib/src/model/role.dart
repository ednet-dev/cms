import 'package:ednet_core/ednet_core.dart';
import 'domain_event.dart';
import 'element.dart';

/// Represents a role in an Event Storming session.
///
/// In Event Storming, roles represent actors or users that initiate commands.
/// They are typically represented by light blue or cyan sticky notes on the event storming board.
class EventStormingRole extends EventStormingElement {
  /// IDs of commands that this role initiates.
  final List<String> initiatedCommandIds;

  /// Permissions associated with this role.
  final List<String> permissions;

  /// Creates a new role.
  EventStormingRole({
    required String id,
    required String name,
    String description = '',
    List<String> tags = const [],
    required Position position,
    this.initiatedCommandIds = const [],
    this.permissions = const [],
    required String createdBy,
    required DateTime createdAt,
    String color = '#87CEEB', // Sky blue by default
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

  /// Creates a role from a map representation.
  factory EventStormingRole.fromJson(Map<String, dynamic> json) {
    return EventStormingRole(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      initiatedCommandIds: (json['initiatedCommandIds'] as List<dynamic>?)?.cast<String>() ?? [],
      permissions: (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#87CEEB',
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
      'initiatedCommandIds': initiatedCommandIds,
      'permissions': permissions,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'elementType': elementType,
    };
  }

  @override
  EventStormingRole copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    List<String>? initiatedCommandIds,
    List<String>? permissions,
    String? createdBy,
    DateTime? createdAt,
    String? color,
  }) {
    return EventStormingRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      initiatedCommandIds: initiatedCommandIds ?? this.initiatedCommandIds,
      permissions: permissions ?? this.permissions,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
    );
  }

  /// Adds an initiated command to this role.
  EventStormingRole addInitiatedCommand(String commandId) {
    if (initiatedCommandIds.contains(commandId)) {
      return this;
    }
    return copyWith(
      initiatedCommandIds: [...initiatedCommandIds, commandId],
    );
  }

  /// Removes an initiated command from this role.
  EventStormingRole removeInitiatedCommand(String commandId) {
    return copyWith(
      initiatedCommandIds: initiatedCommandIds.where((id) => id != commandId).toList(),
    );
  }

  /// Adds a permission to this role.
  EventStormingRole addPermission(String permission) {
    if (permissions.contains(permission)) {
      return this;
    }
    return copyWith(
      permissions: [...permissions, permission],
    );
  }

  /// Removes a permission from this role.
  EventStormingRole removePermission(String permission) {
    return copyWith(
      permissions: permissions.where((p) => p != permission).toList(),
    );
  }

  /// Converts this event storming role to an EDNet Core entity.
  model.Entity toCoreRole() {
    // EDNet Core might not have a direct Role class in its model package
    // So we'll create a generic entity representation
    return model.Entity(
      name: name,
    );
  }
  
  @override
  ednet_core.model.Entity toCoreModelEntity() {
    return toCoreRole();
  }
  
  @override
  String get elementType => 'role';
} 