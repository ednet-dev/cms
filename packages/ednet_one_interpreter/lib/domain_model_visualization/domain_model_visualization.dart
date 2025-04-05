import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/presentation/widgets/layout/graph/algorithms/master_detail_layout_algorithm.dart';
import 'dart:math' as math;

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

  /// Callback when a concept is selected
  final Function(Concept)? onConceptSelected;

  /// Creates a new domain model visualization.
  const DomainModelVisualization({
    Key? key,
    required this.domain,
    required this.model,
    this.useMasterDetailLayout = true,
    this.onConceptSelected,
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

  // Track selected concept for highlighting relationships
  Concept? _selectedConcept;
  // Track navigation history for breadcrumbs
  final List<Concept> _navigationHistory = [];
  // Track expanded concept nodes
  final Set<String> _expandedNodes = {};

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
      _scale = 1.0; // Reset zoom when changing layout
      _calculatePositions(); // Recalculate positions

      // Reset navigation when model changes
      _selectedConcept = null;
      _navigationHistory.clear();
      _expandedNodes.clear();
    }
  }

  void _calculatePositions() {
    conceptPositions = masterDetailLayout.calculatePositions(
      widget.domain,
      widget.model,
    );
  }

  void _selectConcept(Concept concept) {
    setState(() {
      // Add to navigation history if different from current
      if (_selectedConcept != concept) {
        if (_selectedConcept != null) {
          _navigationHistory.add(_selectedConcept!);
        }

        // Keep only the most recent 10 items in history
        if (_navigationHistory.length > 10) {
          _navigationHistory.removeAt(0);
        }

        _selectedConcept = concept;

        // Auto-expand the selected node
        _expandedNodes.add(concept.code);
      }
    });

    // Notify parent if callback is provided
    if (widget.onConceptSelected != null) {
      widget.onConceptSelected!(concept);
    }

    // Scroll to the selected concept
    _scrollToSelectedConcept();
  }

  void _scrollToSelectedConcept() {
    if (_selectedConcept == null) return;

    final position = conceptPositions[_selectedConcept];
    if (position != null) {
      // Calculate the position adjusted for scale and with some margin
      final pos = position.scale(_scale, _scale);

      // Scroll with animation
      Future.delayed(const Duration(milliseconds: 100), () {
        _horizontalController.animateTo(
          math.max(0, pos.dx - 100),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        _verticalController.animateTo(
          math.max(0, pos.dy - 100),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  // Go back in navigation history
  void _navigateBack() {
    if (_navigationHistory.isNotEmpty) {
      setState(() {
        _selectedConcept = _navigationHistory.removeLast();
        _scrollToSelectedConcept();
      });
    }
  }

  // Toggle node expansion
  void _toggleNodeExpansion(String conceptCode) {
    setState(() {
      if (_expandedNodes.contains(conceptCode)) {
        _expandedNodes.remove(conceptCode);
      } else {
        _expandedNodes.add(conceptCode);
      }
    });
  }

  // Check if a concept is related to the selected concept
  bool _isRelatedToCurrent(Concept concept) {
    if (_selectedConcept == null) return false;

    // Check if this concept is a parent of the selected concept
    for (final parent in _selectedConcept!.parents) {
      if (parent.concept == concept) return true;
    }

    // Check if this concept is a child of the selected concept
    for (final child in _selectedConcept!.children) {
      if (child.concept == concept) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Breadcrumb navigation
              if (_navigationHistory.isNotEmpty || _selectedConcept != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed:
                              _navigationHistory.isEmpty
                                  ? null
                                  : () => _navigateBack(),
                          tooltip: 'Go Back',
                        ),
                        const Text('Path: '),
                        ..._navigationHistory.asMap().entries.map((entry) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Jump back to this point in history
                                  setState(() {
                                    final conceptToSelect = entry.value;
                                    // Remove all items after this one
                                    _navigationHistory.removeRange(
                                      entry.key,
                                      _navigationHistory.length,
                                    );
                                    _selectedConcept = conceptToSelect;
                                    _scrollToSelectedConcept();
                                  });
                                },
                                child: Text(
                                  entry.value.code,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(' > '),
                            ],
                          );
                        }),
                        if (_selectedConcept != null)
                          Text(
                            _selectedConcept!.code,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Legend for the diagram
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          border: Border.all(color: Colors.amber.shade700),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('Entry Concept'),
                      const SizedBox(width: 12),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('Regular Concept'),
                      const SizedBox(width: 12),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          border: Border.all(color: Colors.green.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('Selected'),
                      const SizedBox(width: 12),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          border: Border.all(color: Colors.purple.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('Related'),
                    ],
                  ),

                  Row(
                    children: [
                      Text('Master-Detail Layout'),
                      Switch(
                        value: widget.useMasterDetailLayout,
                        onChanged: (value) {
                          // This requires rebuilding the widget with the new layout option
                          setState(() {
                            if (value != widget.useMasterDetailLayout) {
                              _scale = 1.0; // Reset zoom when changing layout
                              _calculatePositions(); // Recalculate positions
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
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Reset View',
                        onPressed: () {
                          setState(() {
                            _scale = 1.0;
                            _horizontalController.jumpTo(0);
                            _verticalController.jumpTo(0);
                            _calculatePositions();
                            _selectedConcept = null;
                            _navigationHistory.clear();
                            _expandedNodes.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: _buildModelVisualization()),
      ],
    );
  }

  Widget _buildModelVisualization() {
    // Handle edge cases where the model is empty
    if (widget.model.concepts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text('This model has no concepts to display.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calculatePositions();
                });
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    // Handle edge cases where we couldn't calculate any positions
    if (conceptPositions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Could not calculate layout positions for this model.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calculatePositions();
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
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
                    try {
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
                          highlightParents: concept == _selectedConcept,
                          highlightChildren: concept == _selectedConcept,
                        ),
                      );
                    } catch (e) {
                      print('Error generating connection: $e');
                      return const SizedBox();
                    }
                  }),

                  // Draw nodes (concepts)
                  ...conceptPositions.entries.map((entry) {
                    try {
                      final concept = entry.key;
                      final position = entry.value;

                      // Determine visual state of this node
                      final isSelected = concept == _selectedConcept;
                      final isRelated = _isRelatedToCurrent(concept);
                      final isExpanded = _expandedNodes.contains(concept.code);

                      return Positioned(
                        left: position.dx * _scale,
                        top: position.dy * _scale,
                        child: _buildInteractiveNodeWidget(
                          concept: concept,
                          isEntry: concept.entry,
                          isSelected: isSelected,
                          isRelated: isRelated,
                          isExpanded: isExpanded,
                        ),
                      );
                    } catch (e) {
                      print('Error positioning concept: $e');
                      return const SizedBox();
                    }
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveNodeWidget({
    required Concept concept,
    bool isEntry = false,
    bool isSelected = false,
    bool isRelated = false,
    bool isExpanded = false,
  }) {
    // Determine node color based on state
    Color nodeColor;
    Color borderColor;

    if (isSelected) {
      nodeColor = Colors.green.shade100;
      borderColor = Colors.green.shade700;
    } else if (isRelated) {
      nodeColor = Colors.purple.shade100;
      borderColor = Colors.purple.shade700;
    } else if (isEntry) {
      nodeColor = Colors.amber.shade100;
      borderColor = Colors.amber.shade700;
    } else {
      nodeColor = Colors.blue.shade50;
      borderColor = Colors.blue.shade300;
    }

    // Count direct relationships
    int parentCount = 0;
    int childCount = 0;
    try {
      parentCount = concept.parents.length;
      childCount = concept.children.length;
    } catch (e) {
      print('Error counting relationships: $e');
    }

    return GestureDetector(
      onTap: () => _selectConcept(concept),
      child: Card(
        color: nodeColor,
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor, width: 2),
        ),
        child: Container(
          width: 150 * _scale,
          constraints: BoxConstraints(minHeight: 80 * _scale),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with concept name and expand button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      concept.code,
                      style: TextStyle(
                        fontWeight:
                            isEntry || isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                        fontSize: 14 * _scale,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (parentCount > 0 || childCount > 0)
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 16 * _scale,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _toggleNodeExpansion(concept.code),
                      tooltip: isExpanded ? 'Collapse' : 'Expand',
                    ),
                ],
              ),

              // Type indicators
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isEntry)
                    Icon(Icons.star, color: Colors.amber, size: 12 * _scale),
                  if (concept.attributes.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: 4 * _scale),
                      child: Icon(
                        Icons.view_list,
                        size: 12 * _scale,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),

              // Show relationships when expanded
              if (isExpanded)
                Padding(
                  padding: EdgeInsets.only(top: 8 * _scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (parentCount > 0) ...[
                        Text(
                          'Parents:',
                          style: TextStyle(
                            fontSize: 12 * _scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ...concept.parents.take(3).map((parent) {
                          final parentConcept = parent.concept;
                          return parentConcept == null
                              ? const SizedBox.shrink()
                              : InkWell(
                                onTap: () => _selectConcept(parentConcept),
                                child: Text(
                                  '↑ ${parentConcept.code}',
                                  style: TextStyle(
                                    fontSize: 11 * _scale,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              );
                        }),
                        if (parentCount > 3)
                          Text(
                            '... and ${parentCount - 3} more',
                            style: TextStyle(
                              fontSize: 10 * _scale,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],

                      if (childCount > 0) ...[
                        SizedBox(height: 4 * _scale),
                        Text(
                          'Children:',
                          style: TextStyle(
                            fontSize: 12 * _scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ...concept.children.take(3).map((child) {
                          final childConcept = child.concept;
                          return childConcept == null
                              ? const SizedBox.shrink()
                              : InkWell(
                                onTap: () => _selectConcept(childConcept),
                                child: Text(
                                  '↓ ${childConcept.code}',
                                  style: TextStyle(
                                    fontSize: 11 * _scale,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              );
                        }),
                        if (childCount > 3)
                          Text(
                            '... and ${childCount - 3} more',
                            style: TextStyle(
                              fontSize: 10 * _scale,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
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
  final bool highlightParents;
  final bool highlightChildren;

  ConnectionPainter({
    required this.sourcePosition,
    required this.concept,
    required this.conceptPositions,
    this.scale = 1.0,
    this.highlightParents = false,
    this.highlightChildren = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    try {
      final nodeSize = Size(nodeWidth * scale, nodeHeight * scale);

      // Draw child connections
      if (concept.children.isNotEmpty) {
        for (final child in concept.children) {
          try {
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

            // Determine if this connection should be highlighted
            final shouldHighlight = highlightChildren;

            // Draw the arrow with different color if highlighted
            _drawArrow(
              canvas,
              sourceCenter,
              targetCenter,
              shouldHighlight ? Colors.green.shade700 : Colors.green,
              shouldHighlight ? 3.0 : 2.0,
            );
          } catch (e) {
            // Skip this child if there was an error
            continue;
          }
        }
      }

      // Draw parent connections
      if (concept.parents.isNotEmpty) {
        for (final parent in concept.parents) {
          try {
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

            // Determine if this connection should be highlighted
            final shouldHighlight = highlightParents;

            // Draw the arrow with different color if highlighted
            _drawArrow(
              canvas,
              targetCenter,
              sourceCenter,
              shouldHighlight ? Colors.blue.shade700 : Colors.blue,
              shouldHighlight ? 3.0 : 2.0,
            );
          } catch (e) {
            // Skip this parent if there was an error
            continue;
          }
        }
      }
    } catch (e) {
      // If anything goes wrong, just don't draw any connections
      print('Error drawing connections: $e');
    }
  }

  void _drawArrow(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    double strokeWidth,
  ) {
    try {
      final paint =
          Paint()
            ..color = color
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke;

      // Create a curved path
      final path = Path();
      path.moveTo(start.dx, start.dy);

      // Calculate the direction vector
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final distance = math.sqrt(dx * dx + dy * dy);

      // If points are too close, just draw a straight line
      if (distance < 10) {
        path.lineTo(end.dx, end.dy);
        canvas.drawPath(path, paint);
        return;
      }

      // Determine control points for a natural curve
      final midPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

      // Add curvature perpendicular to the line between points
      final perpX =
          -dy / distance * math.min(distance / 2, 50); // Limit curvature
      final perpY = dx / distance * math.min(distance / 2, 50);

      final controlPoint = Offset(midPoint.dx + perpX, midPoint.dy + perpY);

      // Draw curve with one control point (quadratic Bezier)
      path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, end.dx, end.dy);

      // Draw the path
      canvas.drawPath(path, paint);

      // Draw an arrowhead at the end
      _drawArrowhead(canvas, end, controlPoint, color, strokeWidth);
    } catch (e) {
      print('Error drawing arrow: $e');
    }
  }

  void _drawArrowhead(
    Canvas canvas,
    Offset tip,
    Offset controlPoint,
    Color color,
    double strokeWidth,
  ) {
    try {
      // Use the control point for direction instead of the start point
      // to make the arrow align with the end of the curve
      final direction = (tip - controlPoint).normalize();

      // Calculate the perpendicular vector
      final perpendicular = Offset(-direction.dy, direction.dx);

      // Calculate the points for the arrowhead
      final arrowSize = 10.0 * scale;
      final point1 =
          tip - direction * arrowSize + perpendicular * arrowSize * 0.5;
      final point2 =
          tip - direction * arrowSize - perpendicular * arrowSize * 0.5;

      // Draw the arrowhead
      final arrowPath =
          Path()
            ..moveTo(tip.dx, tip.dy)
            ..lineTo(point1.dx, point1.dy)
            ..lineTo(point2.dx, point2.dy)
            ..close();

      canvas.drawPath(
        arrowPath,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    } catch (e) {
      print('Error drawing arrowhead: $e');
    }
  }

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    return oldDelegate.sourcePosition != sourcePosition ||
        oldDelegate.concept != concept ||
        oldDelegate.scale != scale ||
        oldDelegate.highlightParents != highlightParents ||
        oldDelegate.highlightChildren != highlightChildren;
  }
}

extension OffsetExtension on Offset {
  Offset normalize() {
    try {
      final magnitude = distance;
      if (magnitude == 0 || magnitude.isNaN) return Offset.zero;
      return scale(1 / magnitude, 1 / magnitude);
    } catch (e) {
      print('Error normalizing offset: $e');
      return Offset.zero;
    }
  }
}
