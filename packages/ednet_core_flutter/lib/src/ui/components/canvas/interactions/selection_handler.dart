part of ednet_core_flutter;

/// A handler for selection gestures on the canvas.
///
/// This class encapsulates the logic for handling selection interactions,
/// identifying which node was tapped, and maintaining selection state.
///
/// This component is part of the EDNet Shell Architecture's visualization system
/// for domain model canvases.
class SelectionHandler {
  String? _selectedNode;
  final TransformationController transformationController;
  final ValueChanged<String?> onSelectionChanged;

  /// Hit test margin for node selection
  final double hitTestMargin;

  /// Constructor for SelectionHandler
  SelectionHandler({
    required this.transformationController,
    required this.onSelectionChanged,
    String? initialSelection,
    this.hitTestMargin = 10.0,
  }) : _selectedNode = initialSelection;

  /// Handles a tap on the canvas, determining if a node was hit
  void handleTap(
    TapUpDetails details,
    BuildContext context,
    Map<String, Offset> layoutPositions,
  ) {
    final renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = transformationController.toScene(
      renderBox.globalToLocal(details.globalPosition),
    );

    // Check if the tap hit any node
    String? tappedNode;

    for (final entry in layoutPositions.entries) {
      final nodeRect = Rect.fromCenter(
        center: entry.value,
        width: 100 + hitTestMargin * 2, // Node width + margin
        height: 50 + hitTestMargin * 2, // Node height + margin
      );

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
    } else {
      // Clear selection when tapping empty space
      if (_selectedNode != null) {
        _selectedNode = null;
        onSelectionChanged(null);
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
