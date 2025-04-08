part of ednet_core_flutter;

/// Represents a relationship between entities to be rendered on the canvas.
///
/// This immutable class encapsulates all the data needed for rendering a relationship,
/// including its endpoints, labels, and visual properties.
///
/// Part of the EDNet Shell Architecture visualization system.
class CanvasRelation extends ValueObject {
  /// The unique ID of this relationship
  final String id;

  /// The source entity ID
  final String sourceId;

  /// The target entity ID
  final String targetId;

  /// The position of the source endpoint
  final Offset sourcePosition;

  /// The position of the target endpoint
  final Offset targetPosition;

  /// The label to display from source to target
  final String sourceToTargetLabel;

  /// The label to display from target to source
  final String targetToSourceLabel;

  /// The color of this relationship
  final Color color;

  /// The line thickness
  final double thickness;

  /// Whether this relationship is currently selected
  final bool isSelected;

  /// Whether to show directional arrows
  final bool showArrows;

  /// The disclosure level that determines detail visibility
  final DisclosureLevel disclosureLevel;

  /// Additional metadata associated with this relationship
  final Map<String, dynamic> metadata;

  /// Creates a new canvas relationship
  CanvasRelation({
    required this.id,
    required this.sourceId,
    required this.targetId,
    required this.sourcePosition,
    required this.targetPosition,
    required this.sourceToTargetLabel,
    this.targetToSourceLabel = '',
    this.color = Colors.grey,
    this.thickness = 1.0,
    this.isSelected = false,
    this.showArrows = true,
    this.disclosureLevel = DisclosureLevel.standard,
    this.metadata = const {},
  }) {
    validate();
  }

  /// The midpoint of this relationship line
  Offset get midpoint => Offset(
        (sourcePosition.dx + targetPosition.dx) / 2,
        (sourcePosition.dy + targetPosition.dy) / 2,
      );

  /// The total length of this relationship line
  double get length => (targetPosition - sourcePosition).distance;

  /// The direction vector of this relationship
  Offset get direction {
    final delta = targetPosition - sourcePosition;
    final distance = delta.distance;
    if (distance < 0.0001) return Offset.zero;
    return Offset(delta.dx / distance, delta.dy / distance);
  }

  /// Check if a point is near this relationship line
  bool isNearPoint(Offset point, {double threshold = 10.0}) {
    // Calculate distance from point to line segment
    final length = (targetPosition - sourcePosition).distance;
    if (length == 0) return false;

    final t = math.max(
        0.0,
        math.min(
            1.0,
            (((point - sourcePosition).dx *
                            (targetPosition - sourcePosition).dx +
                        (point - sourcePosition).dy *
                            (targetPosition - sourcePosition).dy) /
                    (length * length))
                .toDouble()));

    final projection = sourcePosition + (targetPosition - sourcePosition) * t;

    final distance = (point - projection).distance;

    return distance <= threshold;
  }

  /// Create a selected version of this relationship
  CanvasRelation select() {
    if (isSelected) return this;
    return copyWith(isSelected: true);
  }

  /// Create a deselected version of this relationship
  CanvasRelation deselect() {
    if (!isSelected) return this;
    return copyWith(isSelected: false);
  }

  /// Add metadata to this relationship
  CanvasRelation withMetadata(String key, dynamic value) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata[key] = value;
    return copyWith(metadata: newMetadata);
  }

  @override
  void validate() {
    if (id.isEmpty) {
      throw ValidationException('id', 'Relationship ID cannot be empty');
    }
    if (sourceId.isEmpty) {
      throw ValidationException('sourceId', 'Source ID cannot be empty');
    }
    if (targetId.isEmpty) {
      throw ValidationException('targetId', 'Target ID cannot be empty');
    }
    if (thickness <= 0) {
      throw ValidationException('thickness', 'Thickness must be positive');
    }
  }

  @override
  List<Object> get props => [
        id,
        sourceId,
        targetId,
        sourcePosition,
        targetPosition,
        sourceToTargetLabel,
        targetToSourceLabel,
        color,
        thickness,
        isSelected,
        showArrows,
        disclosureLevel,
        metadata.toString(),
      ];

  @override
  CanvasRelation copyWith({
    String? id,
    String? sourceId,
    String? targetId,
    Offset? sourcePosition,
    Offset? targetPosition,
    String? sourceToTargetLabel,
    String? targetToSourceLabel,
    Color? color,
    double? thickness,
    bool? isSelected,
    bool? showArrows,
    DisclosureLevel? disclosureLevel,
    Map<String, dynamic>? metadata,
  }) {
    return CanvasRelation(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      sourcePosition: sourcePosition ?? this.sourcePosition,
      targetPosition: targetPosition ?? this.targetPosition,
      sourceToTargetLabel: sourceToTargetLabel ?? this.sourceToTargetLabel,
      targetToSourceLabel: targetToSourceLabel ?? this.targetToSourceLabel,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      isSelected: isSelected ?? this.isSelected,
      showArrows: showArrows ?? this.showArrows,
      disclosureLevel: disclosureLevel ?? this.disclosureLevel,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Creates a LineNode representation of this relationship
  LineNode toLineNode() {
    return LineNode(
      start: sourcePosition,
      end: targetPosition,
      sourceToTargetLabel: _getFormattedLabel(sourceToTargetLabel),
      targetToSourceLabel: _getFormattedLabel(targetToSourceLabel),
      color: color,
      thickness: isSelected ? thickness * 1.5 : thickness,
    );
  }

  /// Format a label based on disclosure level
  String _getFormattedLabel(String label) {
    if (label.isEmpty) return '';

    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        // Just show first letter
        return label.length <= 1 ? label : label[0];
      case DisclosureLevel.basic:
        // Show abbreviated label
        return label.length <= 3 ? label : '${label.substring(0, 3)}...';
      case DisclosureLevel.standard:
        // Show moderate length
        return label.length <= 10 ? label : '${label.substring(0, 10)}...';
      case DisclosureLevel.advanced:
      case DisclosureLevel.complete:
        // Show full label
        return label;
      default:
        return label.length <= 10 ? label : '${label.substring(0, 10)}...';
    }
  }
}
