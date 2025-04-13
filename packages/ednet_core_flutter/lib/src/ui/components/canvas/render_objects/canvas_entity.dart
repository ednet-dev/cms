part of ednet_core_flutter;

/// Represents an entity to be rendered on the canvas.
///
/// This immutable class encapsulates all the data needed for rendering an entity,
/// including its position, color, and other visual properties.
///
/// Part of the EDNet Shell Architecture visualization system.
class CanvasEntity extends ValueObject {
  /// The unique ID of this entity
  final String id;

  /// The display label
  final String label;

  /// The position on the canvas
  final Offset position;

  /// The color of this entity
  final Color color;

  /// Whether this entity is currently selected
  final bool isSelected;

  /// The type of this entity
  final EntityType type;

  /// Additional metadata associated with this entity
  final Map<String, dynamic> metadata;

  /// The width of the entity box
  final double width;

  /// The height of the entity box
  final double height;

  /// Creates a new canvas entity
  CanvasEntity({
    required this.id,
    required this.label,
    required this.position,
    required this.color,
    this.isSelected = false,
    this.type = EntityType.concept,
    this.metadata = const {},
    this.width = 100,
    this.height = 50,
  }) {
    validate();
  }

  /// The rectangle that represents this entity's bounds
  Rect get bounds =>
      Rect.fromCenter(center: position, width: width, height: height);

  /// Check if a point is within this entity's bounds
  bool containsPoint(Offset point) {
    return bounds.contains(point);
  }

  /// Create a selected version of this entity
  CanvasEntity select() {
    if (isSelected) return this;
    return copyWith(isSelected: true);
  }

  /// Create a deselected version of this entity
  CanvasEntity deselect() {
    if (!isSelected) return this;
    return copyWith(isSelected: false);
  }

  /// Add metadata to this entity
  CanvasEntity withMetadata(String key, value) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata[key] = value;
    return copyWith(metadata: newMetadata);
  }

  @override
  void validate() {
    if (id.isEmpty) {
      throw ValidationException('id', 'Entity ID cannot be empty');
    }
    if (width <= 0 || height <= 0) {
      throw ValidationException(
          'dimensions', 'Entity dimensions must be positive');
    }
  }

  @override
  List<Object> get props => [
        id,
        label,
        position,
        color,
        isSelected,
        type,
        metadata.toString(),
        width,
        height,
      ];

  @override
  CanvasEntity copyWith({
    String? id,
    String? label,
    Offset? position,
    Color? color,
    bool? isSelected,
    EntityType? type,
    Map<String, dynamic>? metadata,
    double? width,
    double? height,
  }) {
    return CanvasEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      position: position ?? this.position,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  /// Creates a VisualNode representation of this entity
  VisualNode toVisualNode() {
    return VisualNode(
      position: position,
      color: color,
      type: type.name,
      label: label,
      size: math.max(width, height),
      isSelected: isSelected,
      data: metadata,
    );
  }
}

/// The type of entity being rendered
enum EntityType {
  /// A domain (highest level container)
  domain,

  /// A model (container for concepts)
  model,

  /// A concept (core entity)
  concept,

  /// An attribute (property)
  attribute,

  /// A relationship between entities
  relationship
}
