// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;






class FlowEdge {
  /// The unique identifier for this edge.
  final String id;

  /// The display label for this edge.
  final String label;

  /// The source node where this edge originates.
  final TreeNode? source;

  /// The target node where this edge terminates.
  final TreeNode? target;

  /// The type of this edge.
  final EdgeType type;

  /// The direction of this edge.
  final EdgeDirection direction;

  /// Whether this edge has a specific visual style.
  final bool hasCustomStyling;

  /// The color of this edge.
  final Color color;

  /// The width of this edge.
  final double width;

  /// Whether this edge is drawn with a dashed line.
  final bool isDashed;

  /// Control points for a bezier curve (if used).
  List<Offset> controlPoints;

  /// Additional data associated with this edge.
  final Map<String, dynamic> data;

  /// Creates a new flow edge.
  FlowEdge({
    required this.id,
    this.label = '',
    this.source,
    this.target,
    this.type = EdgeType.association,
    this.direction = EdgeDirection.leftToRight,
    this.hasCustomStyling = false,
    this.color = const Color(0xFF000000),
    this.width = 1.0,
    this.isDashed = false,
    List<Offset>? controlPoints,
    this.data = const {},
  }) : controlPoints = controlPoints ?? [];

  /// Updates the positions of this edge based on its source and target nodes.
  ///
  /// This method recalculates the edge's control points based on the current
  /// positions of its source and target nodes. It's typically called after
  /// a layout algorithm has positioned the nodes.
  void updatePositions() {
    if (source == null || target == null) return;

    // Default to straight line (two control points)
    final sourcePos = source!.position;
    final targetPos = target!.position;

    // Clear existing control points
    controlPoints.clear();

    // For straight lines, just use source and target positions
    controlPoints.add(sourcePos);
    controlPoints.add(targetPos);

    // For curved edges with custom logic, additional control points
    // would be added here based on the edge type and direction
  }

  /// Creates a bezier curve for this edge.
  ///
  /// This method calculates appropriate control points for a bezier curve
  /// connecting the source and target nodes. It's useful for creating visually
  /// pleasing curved edges in visualizations.
  ///
  /// Parameters:
  /// - [curvature]: The amount of curvature (0.0 = straight line, higher values = more curve)
  void createBezierCurve(double curvature) {
    if (source == null || target == null) return;

    final sourcePos = source!.position;
    final targetPos = target!.position;

    // Calculate the midpoint between source and target
    final midX = (sourcePos.dx + targetPos.dx) / 2;
    final midY = (sourcePos.dy + targetPos.dy) / 2;

    // Calculate the perpendicular offset for the control point
    final dx = targetPos.dx - sourcePos.dx;
    final dy = targetPos.dy - sourcePos.dy;
    final length = (dx * dx + dy * dy).sqrt();

    // Skip if points are too close
    if (length < 1.0) {
      controlPoints = [sourcePos, targetPos];
      return;
    }

    // Perpendicular vector
    final perpX = -dy / length * curvature;
    final perpY = dx / length * curvature;

    // Set control points for a quadratic bezier
    controlPoints = [sourcePos, Offset(midX + perpX, midY + perpY), targetPos];
  }

  /// Creates a flow edge from a relation between nodes.
  ///
  /// This factory method simplifies creating edges that represent domain
  /// relationships between nodes.
  ///
  /// Parameters:
  /// - [sourceNode]: The source node
  /// - [targetNode]: The target node
  /// - [label]: The label for the edge
  /// - [edgeType]: The type of edge
  ///
  /// Returns:
  /// A new FlowEdge connecting the source and target nodes
  factory FlowEdge.fromRelation(
    TreeNode sourceNode,
    TreeNode targetNode,
    String label,
    EdgeType edgeType,
  ) {
    return FlowEdge(
      id: '${sourceNode.id}_${label}_${targetNode.id}',
      label: label,
      source: sourceNode,
      target: targetNode,
      type: edgeType,
      data: {
        'sourceId': sourceNode.id,
        'targetId': targetNode.id,
        'label': label,
      },
    );
  }

  /// Converts this edge to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'sourceId': source?.id,
      'targetId': target?.id,
      'type': type.toString(),
      'direction': direction.toString(),
      'color': color.value,
      'width': width,
      'isDashed': isDashed,
      'controlPoints':
          controlPoints.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'data': data,
    };
  }
}

class VisualEdge {
  /// The source node where this edge originates.
  final VisualNode source;

  /// The target node where this edge terminates.
  final VisualNode target;

  /// The display label for this edge.
  final String? label;

  /// Additional data associated with this edge.
  final Map<String, dynamic> data;

  /// Creates a new visual edge.
  const VisualEdge({
    required this.source,
    required this.target,
    this.label,
    this.data = const {},
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VisualEdge) return false;
    return source == other.source &&
        target == other.target &&
        label == other.label;
  }

  @override
  int get hashCode => Object.hash(source, target, label);
}
