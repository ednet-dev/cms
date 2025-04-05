import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/presentation/widgets/layout/graph/algorithms/master_detail_layout_algorithm.dart';

/// A widget that visualizes a domain model.
///
/// This widget creates a visual representation of a domain model with concepts
/// as nodes and their relationships as edges.
class DomainModelVisualization extends StatefulWidget {
  /// The domain containing the model to visualize.
  final Domain domain;

  /// The model to visualize.
  final Model model;

  /// Whether to use master detail layout instead of force directed
  final bool useMasterDetailLayout;

  /// Creates a new domain model visualization.
  const DomainModelVisualization({
    Key? key,
    required this.domain,
    required this.model,
    this.useMasterDetailLayout = true,
  }) : super(key: key);

  @override
  State<DomainModelVisualization> createState() =>
      _DomainModelVisualizationState();
}

class _DomainModelVisualizationState extends State<DomainModelVisualization> {
  late MasterDetailLayoutAlgorithm masterDetailLayout;
  Map<Concept, Offset> conceptPositions = {};
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    masterDetailLayout = const MasterDetailLayoutAlgorithm();
    _calculatePositions();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DomainModelVisualization oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model ||
        oldWidget.domain != widget.domain ||
        oldWidget.useMasterDetailLayout != widget.useMasterDetailLayout) {
      _calculatePositions();
    }
  }

  void _calculatePositions() {
    conceptPositions = masterDetailLayout.calculatePositions(
      widget.domain,
      widget.model,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Master-Detail Layout'),
              Switch(
                value: widget.useMasterDetailLayout,
                onChanged: (value) {
                  // This requires rebuilding the widget with the new layout option
                  setState(() {
                    if (value != widget.useMasterDetailLayout) {
                      // We'll just trigger a rebuild since we're using state now
                    }
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () {
                  setState(() {
                    _scale += 0.1;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () {
                  setState(() {
                    _scale = (_scale - 0.1).clamp(0.5, 3.0);
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            child: Scrollbar(
              controller: _verticalController,
              thumbVisibility: true,
              notificationPredicate: (notification) => notification.depth == 1,
              child: SingleChildScrollView(
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  child: SizedBox(
                    width: 2000,
                    height: 1500,
                    child: Stack(
                      children: [
                        // Draw edges (connections)
                        ...List.generate(widget.model.concepts.length, (i) {
                          final concept = widget.model.concepts.elementAt(i);
                          final sourcePos = conceptPositions[concept];
                          if (sourcePos == null) return const SizedBox();

                          return CustomPaint(
                            size: const Size(2000, 1500),
                            painter: ConnectionPainter(
                              sourcePosition: sourcePos,
                              concept: concept,
                              conceptPositions: conceptPositions,
                              scale: _scale,
                            ),
                          );
                        }),

                        // Draw nodes (concepts)
                        ...conceptPositions.entries.map((entry) {
                          final concept = entry.key;
                          final position = entry.value;

                          return Positioned(
                            left: position.dx * _scale,
                            top: position.dy * _scale,
                            child: _buildNodeWidget(
                              concept.code,
                              isEntry: concept.entry,
                              concept: concept,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNodeWidget(
    String name, {
    bool isEntry = false,
    Concept? concept,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 150 * _scale,
      constraints: BoxConstraints(minHeight: 80 * _scale),
      decoration: BoxDecoration(
        color: isEntry ? Colors.amber.shade100 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isEntry ? Colors.amber.shade700 : Colors.blue.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEntry) const Icon(Icons.star, color: Colors.amber, size: 16),
          Text(
            name,
            style: TextStyle(
              fontWeight: isEntry ? FontWeight.bold : FontWeight.normal,
              fontSize: 14 * _scale,
            ),
          ),
          if (concept != null && concept.attributes.isNotEmpty)
            Icon(Icons.view_list, size: 12 * _scale, color: Colors.grey),
        ],
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final Offset sourcePosition;
  final Concept concept;
  final Map<Concept, Offset> conceptPositions;
  final double scale;
  final double nodeWidth = 150;
  final double nodeHeight = 80;

  ConnectionPainter({
    required this.sourcePosition,
    required this.concept,
    required this.conceptPositions,
    this.scale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodeSize = Size(nodeWidth * scale, nodeHeight * scale);

    // Draw child connections
    for (final child in concept.children) {
      final childConcept = child.concept;
      if (childConcept == null) continue;

      final targetPosition = conceptPositions[childConcept];
      if (targetPosition == null) continue;

      // Calculate centers for source and target
      final sourceCenter =
          sourcePosition.scale(scale, scale) +
          Offset(nodeSize.width / 2, nodeSize.height / 2);
      final targetCenter =
          targetPosition.scale(scale, scale) +
          Offset(nodeSize.width / 2, nodeSize.height / 2);

      // Draw the arrow
      _drawArrow(canvas, sourceCenter, targetCenter, Colors.green, 2.0);
    }

    // Draw parent connections
    for (final parent in concept.parents) {
      final parentConcept = parent.concept;
      if (parentConcept == null) continue;

      final targetPosition = conceptPositions[parentConcept];
      if (targetPosition == null) continue;

      // Calculate centers for source and target
      final sourceCenter =
          sourcePosition.scale(scale, scale) +
          Offset(nodeSize.width / 2, nodeSize.height / 2);
      final targetCenter =
          targetPosition.scale(scale, scale) +
          Offset(nodeSize.width / 2, nodeSize.height / 2);

      // Draw the arrow
      _drawArrow(canvas, targetCenter, sourceCenter, Colors.blue, 2.0);
    }
  }

  void _drawArrow(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    double strokeWidth,
  ) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    // Create a curved path
    final path = Path();
    path.moveTo(start.dx, start.dy);

    // Determine control points for the curve
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;
    final controlY = midY - (end.dx - start.dx) * 0.2;

    path.quadraticBezierTo(midX, controlY, end.dx, end.dy);

    // Draw the path
    canvas.drawPath(path, paint);

    // Draw an arrowhead at the end
    _drawArrowhead(canvas, end, start, paint);
  }

  void _drawArrowhead(Canvas canvas, Offset tip, Offset from, Paint paint) {
    // Calculate the direction from the end point to the start point
    final direction = (from - tip).normalize();

    // Calculate the perpendicular vector
    final perpendicular = Offset(-direction.dy, direction.dx);

    // Calculate the points for the arrowhead
    final arrowSize = 10.0 * scale;
    final point1 =
        tip + direction * arrowSize + perpendicular * arrowSize * 0.5;
    final point2 =
        tip + direction * arrowSize - perpendicular * arrowSize * 0.5;

    // Draw the arrowhead
    final arrowPath =
        Path()
          ..moveTo(tip.dx, tip.dy)
          ..lineTo(point1.dx, point1.dy)
          ..lineTo(point2.dx, point2.dy)
          ..close();

    canvas.drawPath(arrowPath, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    return oldDelegate.sourcePosition != sourcePosition ||
        oldDelegate.concept != concept ||
        oldDelegate.scale != scale;
  }
}

extension OffsetExtension on Offset {
  Offset normalize() {
    final magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return scale(1 / magnitude, 1 / magnitude);
  }
}
