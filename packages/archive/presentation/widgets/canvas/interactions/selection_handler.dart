import 'package:flutter/material.dart';

/// A handler for selection gestures on the canvas.
///
/// This class encapsulates the logic for handling selection interactions,
/// identifying which node was tapped, and maintaining selection state.
class SelectionHandler {
  String? _selectedNode;
  final TransformationController transformationController;
  final ValueChanged<String?> onSelectionChanged;

  SelectionHandler({
    required this.transformationController,
    required this.onSelectionChanged,
    String? initialSelection,
  }) : _selectedNode = initialSelection;

  /// Handles a tap on the canvas, determining if a node was hit
  void handleTap(
    TapUpDetails details,
    BuildContext context,
    Map<String, Offset> layoutPositions,
  ) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = transformationController.toScene(
      renderBox.globalToLocal(details.globalPosition),
    );

    // Check if the tap hit any node
    const double margin = 10.0; // Hit detection margin
    String? tappedNode;

    for (var entry in layoutPositions.entries) {
      final nodeRect = Rect.fromCenter(
        center: entry.value,
        width: 100 + margin * 2, // Node width + margin
        height: 50 + margin * 2,
      ); // Node height + margin

      if (nodeRect.contains(tapPosition)) {
        tappedNode = entry.key;
        break;
      }
    }

    // Update selection state if a node was hit
    if (tappedNode != null) {
      // Toggle selection if the same node is tapped again
      final newSelection = tappedNode == _selectedNode ? null : tappedNode;

      if (newSelection != _selectedNode) {
        _selectedNode = newSelection;
        onSelectionChanged(_selectedNode);
      }
    }
  }

  /// Get the currently selected node
  String? get selectedNode => _selectedNode;

  /// Set the selected node
  set selectedNode(String? value) {
    if (value != _selectedNode) {
      _selectedNode = value;
      onSelectionChanged(_selectedNode);
    }
  }
}
