// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;






abstract class DomainComponent extends Component {
  /// The unique identifier for this component.
  final String id;

  /// The display name of this component.
  final String name;

  /// The description of this component.
  final String description;

  /// The position of this component in the game world.
  Vector2 position;

  /// The size of this component in the game world.
  Vector2 size;

  /// Whether this component can be dragged by the user.
  bool draggable;

  /// Whether this component is currently selected.
  bool selected;

  /// The color of this component.
  int color;

  /// Creates a new domain component.
  DomainComponent({
    required this.id,
    required this.name,
    this.description = '',
    required Vector2 position,
    Vector2? size,
    this.draggable = true,
    this.selected = false,
    required this.color,
  }) : position = position.clone(),
       size = size?.clone() ?? Vector2(100, 60);

  /// Converts the component to a serializable map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'position': {'x': position.x, 'y': position.y},
      'size': {'width': size.x, 'height': size.y},
      'draggable': draggable,
      'selected': selected,
      'color': color,
    };
  }

  /// Creates a component from a serialized map.
  static DomainComponent fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Subclasses must implement fromJson');
  }

  /// Converts this component to an EDNet Core domain model entity.
  Entity<T> toDomainEntity<T extends Entity<T>>() {
    throw UnimplementedError('Subclasses must implement toDomainEntity');
  }
}

class GameEntityComponent extends DomainComponent {
  /// The attributes of this entity.
  final List<AttributeComponent> attributes;

  /// Whether this entity is an aggregate root.
  final bool isAggregateRoot;

  /// Creates a new entity component.
  EntityComponent({
    required super.id,
    required super.name,
    super.description,
    required super.position,
    super.size,
    super.draggable,
    super.selected,
    required super.color,
    this.attributes = const [],
    this.isAggregateRoot = false,
  });

  /// Creates an entity component from a serialized map.
  factory EntityComponent.fromJson(Map<String, dynamic> json) {
    return EntityComponent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      position: Vector2(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      size: Vector2(
        (json['size']['width'] as num).toDouble(),
        (json['size']['height'] as num).toDouble(),
      ),
      draggable: json['draggable'] as bool? ?? true,
      selected: json['selected'] as bool? ?? false,
      color: json['color'] as int,
      isAggregateRoot: json['isAggregateRoot'] as bool? ?? false,
      attributes:
          (json['attributes'] as List?)
              ?.map(
                (e) => AttributeComponent.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['attributes'] = attributes.map((a) => a.toJson()).toList();
    json['isAggregateRoot'] = isAggregateRoot;
    return json;
  }

  @override
  Entity<T> toDomainEntity<T extends Entity<T>>() {
    // This is a simplified implementation; in a real implementation,
    // you would need to create a proper entity with attributes
    throw UnimplementedError(
      'Need to implement based on actual EDNet Core API',
    );
  }
}

class AttributeComponent extends DomainComponent {
  /// The type of this attribute (String, int, etc.).
  final String type;

  /// The parent entity ID that this attribute belongs to.
  final String entityId;

  /// Creates a new attribute component.
  AttributeComponent({
    required super.id,
    required super.name,
    super.description,
    required super.position,
    super.size,
    super.draggable,
    super.selected,
    required super.color,
    required this.type,
    required this.entityId,
  });

  /// Creates an attribute component from a serialized map.
  factory AttributeComponent.fromJson(Map<String, dynamic> json) {
    return AttributeComponent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      position: Vector2(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      size: Vector2(
        (json['size']['width'] as num).toDouble(),
        (json['size']['height'] as num).toDouble(),
      ),
      draggable: json['draggable'] as bool? ?? true,
      selected: json['selected'] as bool? ?? false,
      color: json['color'] as int,
      type: json['type'] as String,
      entityId: json['entityId'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = type;
    json['entityId'] = entityId;
    return json;
  }
}
