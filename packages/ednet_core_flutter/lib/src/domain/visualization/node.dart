part of ednet_core_flutter;

/// A visual node in the domain visualization system.
///
/// Nodes are the basic visual elements that can be rendered on the canvas.
/// They can represent entities, relationships, or any other visual element.
///
/// Node is implemented as a ValueObject as it is identified by its properties,
/// has no identity separate from its value, and should be immutable.
class VisualNode extends ValueObject {
  /// The position of this node on the canvas
  final Offset position;

  /// The color of this node
  final Color color;

  /// The type of this node (entity, relationship, etc.)
  final String type;

  /// The label for this node (usually an entity code)
  final String label;

  /// The size of this node when rendered
  final double size;

  /// Whether this node is currently selected
  final bool isSelected;

  /// The visual weight of this node (used for force-directed layouts)
  final double weight;

  /// Custom data associated with this node
  final Map<String, dynamic> data;

  /// Create a new node
  VisualNode({
    required this.position,
    required this.color,
    required this.type,
    required this.label,
    this.size = 50.0,
    this.isSelected = false,
    this.weight = 1.0,
    Map<String, dynamic>? data,
  }) : data = data ?? {} {
    validate();
  }

  @override
  void validate() {
    if (label.isEmpty) {
      throw ValidationException('label', 'Node label cannot be empty');
    }
    if (size <= 0) {
      throw ValidationException('size', 'Node size must be positive');
    }
    if (weight < 0) {
      throw ValidationException('weight', 'Node weight cannot be negative');
    }
  }

  @override
  List<Object> get props =>
      [position, color, type, label, size, isSelected, weight, data.toString()];

  /// Create a copy of this node with optional changes
  @override
  VisualNode copyWith({
    Offset? position,
    Color? color,
    String? type,
    String? label,
    double? size,
    bool? isSelected,
    double? weight,
    Map<String, dynamic>? data,
  }) {
    return VisualNode(
      position: position ?? this.position,
      color: color ?? this.color,
      type: type ?? this.type,
      label: label ?? this.label,
      size: size ?? this.size,
      isSelected: isSelected ?? this.isSelected,
      weight: weight ?? this.weight,
      data: data ?? Map.from(this.data),
    );
  }

  /// Render this node on the canvas - while this is a rendering method,
  /// it doesn't modify the ValueObject's state
  void render(Canvas canvas) {
    // Base implementation - rendering logic for a node
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw circle by default
    canvas.drawCircle(position, size / 2, paint);

    // Draw border if selected
    if (isSelected) {
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(position, size / 2 + 2, borderPaint);
    }
  }

  /// Render text for this node - while this is a rendering method,
  /// it doesn't modify the ValueObject's state
  void renderText(Canvas canvas) {
    // Create text painter
    final textStyle = TextStyle(
      color: _getContrastColor(color),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: label,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
    );

    // Layout and paint text
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  /// Calculate if this node contains the given point
  bool contains(Offset point) {
    return (position - point).distance <= size / 2;
  }

  /// Get a contrasting color for text
  Color _getContrastColor(Color background) {
    // Calculate perceived brightness using the formula
    // (299*R + 587*G + 114*B) / 1000
    final brightness =
        (299 * background.r + 587 * background.g + 114 * background.b) / 1000;

    // Use white for dark backgrounds, black for light backgrounds
    return brightness > 125 ? Colors.black : Colors.white;
  }
}

/// A node that represents a line or relationship between two entities
class LineNode extends VisualNode {
  /// The start position of the line
  final Offset start;

  /// The end position of the line
  final Offset end;

  /// The label for the relationship from source to target
  final String sourceToTargetLabel;

  /// The label for the relationship from target to source
  final String targetToSourceLabel;

  /// The thickness of the line
  final double thickness;

  /// Create a new line node
  LineNode({
    required this.start,
    required this.end,
    required this.sourceToTargetLabel,
    required this.targetToSourceLabel,
    required Color color,
    this.thickness = 1.0,
  }) : super(
          position: Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2),
          color: color,
          type: 'relationship',
          label: sourceToTargetLabel,
        );

  @override
  List<Object> get props => [
        ...super.props,
        start,
        end,
        sourceToTargetLabel,
        targetToSourceLabel,
        thickness
      ];

  @override
  LineNode copyWith({
    Offset? position,
    Offset? start,
    Offset? end,
    String? sourceToTargetLabel,
    String? targetToSourceLabel,
    Color? color,
    double? thickness,
    // Support base class properties too
    String? type,
    String? label,
    double? size,
    bool? isSelected,
    double? weight,
    Map<String, dynamic>? data,
  }) {
    return LineNode(
      start: start ?? this.start,
      end: end ?? this.end,
      sourceToTargetLabel: sourceToTargetLabel ?? this.sourceToTargetLabel,
      targetToSourceLabel: targetToSourceLabel ?? this.targetToSourceLabel,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
    ).copyWith(
      position: position,
      type: type ?? this.type,
      label: label ?? this.label,
      size: size ?? this.size,
      isSelected: isSelected ?? this.isSelected,
      weight: weight ?? this.weight,
      data: data ?? this.data,
    );
  }

  @override
  void validate() {
    super.validate();
    if (thickness <= 0) {
      throw ValidationException('thickness', 'Line thickness must be positive');
    }
    if (sourceToTargetLabel.isEmpty) {
      throw ValidationException(
          'sourceToTargetLabel', 'Source to target label cannot be empty');
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    // Draw the main line
    canvas.drawLine(start, end, paint);

    // Draw direction arrow
    _drawArrow(canvas, start, end, paint);
  }

  @override
  void renderText(Canvas canvas) {
    // Calculate the midpoint of the line
    final midpoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    // Create text painter
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      backgroundColor: Colors.black.withValues(alpha: 128),
    );

    final textSpan = TextSpan(
      text: sourceToTargetLabel,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
    );

    // Layout and paint text
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        midpoint.dx - textPainter.width / 2,
        midpoint.dy - textPainter.height / 2,
      ),
    );

    // Optionally draw the inverse relationship label
    if (targetToSourceLabel.isNotEmpty &&
        targetToSourceLabel != sourceToTargetLabel) {
      final inverseSpan = TextSpan(
        text: targetToSourceLabel,
        style: textStyle,
      );

      final inversePainter = TextPainter(
        text: inverseSpan,
      );

      inversePainter.layout();
      inversePainter.paint(
        canvas,
        Offset(
          midpoint.dx - inversePainter.width / 2,
          midpoint.dy + 10, // Position below the first label
        ),
      );
    }
  }

  @override
  bool contains(Offset point) {
    // Calculate distance from point to line
    final length = (end - start).distance;
    if (length == 0) return false;

    final t = math.max(
        0.0,
        math.min(
            1.0,
            ((point - start).dx * (end - start).dx +
                    (point - start).dy * (end - start).dy) /
                (length * length)));

    final projection = start + (end - start) * t;
    final distance = (point - projection).distance;

    return distance <= 10.0; // 10px hit area for lines
  }

  /// Draw an arrow at the end of the line
  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint linePaint) {
    // Calculate direction vector
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    // Normalize direction vector
    final dirX = distance > 0 ? dx / distance : 0;
    final dirY = distance > 0 ? dy / distance : 0;
    final direction = Offset(dirX.toDouble(), dirY.toDouble());

    // Calculate perpendicular vectors
    final perpendicular = Offset(-dirY.toDouble(), dirX.toDouble());

    // Calculate arrow points
    const arrowSize = 10.0;
    final tip = end - direction * 5.0; // Pull back slightly from the end
    final side1 = tip - direction * arrowSize + perpendicular * arrowSize * 0.5;
    final side2 = tip - direction * arrowSize - perpendicular * arrowSize * 0.5;

    // Draw arrow
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(side1.dx, side1.dy)
      ..lineTo(side2.dx, side2.dy)
      ..close();

    canvas.drawPath(
        path,
        Paint()
          ..color = linePaint.color
          ..style = PaintingStyle.fill);
  }
}
