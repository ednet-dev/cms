part of ednet_core_flutter;

/// A system that manages a collection of visual nodes for domain visualization.
///
/// The VisualizationSystem is responsible for:
/// - Managing a collection of nodes
/// - Rendering nodes on a canvas
/// - Handling interactions with nodes
/// - Maintaining consistency of the visualization
///
/// This class is modeled as an AggregateRoot in DDD terms, as it's the
/// consistency boundary and entry point for visualization operations.
class VisualizationSystem extends AggregateRoot<VisualizationSystem> {
  /// The collection of visual nodes managed by this system
  final List<VisualNode> _nodes = [];

  /// Access to the nodes (as an unmodifiable list)
  List<VisualNode> get nodes => List.unmodifiable(_nodes);

  /// Create a new visualization system
  VisualizationSystem() {
    // Initialize the aggregate root
    super.code = 'visualization_system';
  }

  /// Add a node to the system
  void addNode(VisualNode node) {
    // Record this as a domain event
    recordEvent(
      'NodeAdded',
      'A node was added to the visualization system',
      ['VisualizationUpdated'],
      data: {'node': node.toString()},
    );

    _nodes.add(node);
  }

  /// Remove a node from the system
  void removeNode(VisualNode node) {
    if (_nodes.contains(node)) {
      recordEvent(
        'NodeRemoved',
        'A node was removed from the visualization system',
        ['VisualizationUpdated'],
        data: {'node': node.toString()},
      );

      _nodes.remove(node);
    }
  }

  /// Update a node with a new version
  void updateNode(VisualNode oldNode, VisualNode newNode) {
    int index = _nodes.indexOf(oldNode);
    if (index >= 0) {
      recordEvent(
        'NodeUpdated',
        'A node was updated in the visualization system',
        ['VisualizationUpdated'],
        data: {
          'oldNode': oldNode.toString(),
          'newNode': newNode.toString(),
        },
      );

      _nodes[index] = newNode;
    }
  }

  /// Clear all nodes from the system
  void clear() {
    recordEvent(
      'AllNodesCleared',
      'All nodes were cleared from the visualization system',
      ['VisualizationUpdated'],
      data: {'nodeCount': _nodes.length},
    );

    _nodes.clear();
  }

  /// Find a node at the given position
  VisualNode? findNodeAt(Offset position) {
    // Check in reverse order to prioritize nodes drawn on top
    for (int i = _nodes.length - 1; i >= 0; i--) {
      if (_nodes[i].contains(position)) {
        return _nodes[i];
      }
    }
    return null;
  }

  /// Find a node by label
  VisualNode? findNodeByLabel(String label) {
    for (final node in _nodes) {
      if (node.label == label) {
        return node;
      }
    }
    return null;
  }

  /// Set the selected node
  void selectNode(String? label) {
    final List<VisualNode> updatedNodes = [];

    for (final node in _nodes) {
      final bool shouldBeSelected = node.label == label;

      // Only create a new node if selection state changes
      if (node.isSelected != shouldBeSelected) {
        updatedNodes.add(node.copyWith(isSelected: shouldBeSelected));
      } else {
        updatedNodes.add(node);
      }
    }

    if (!_nodesEqual(_nodes, updatedNodes)) {
      recordEvent(
        'NodeSelectionChanged',
        'Node selection was changed',
        ['VisualizationUpdated'],
        data: {'selectedLabel': label},
      );

      _nodes.clear();
      _nodes.addAll(updatedNodes);
    }
  }

  /// Helper method to compare two node lists
  bool _nodesEqual(List<VisualNode> list1, List<VisualNode> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }

  /// Apply the given event to update the system's state
  @override
  void applyEvent(dynamic event) {
    // This would normally update state based on event type
    // but we're directly modifying state in the command methods
  }

  /// Enforce business invariants for this aggregate
  @override
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();

    // For this system, we might check things like:
    // - No duplicate node labels
    // - No overlapping nodes
    // - Valid relationship structures

    // Check for duplicate labels
    final seenLabels = <String>{};
    for (final node in _nodes) {
      if (seenLabels.contains(node.label)) {
        exceptions.add(ValidationException(
          'uniqueLabels',
          'Duplicate node label found: ${node.label}',
        ));
      }
      seenLabels.add(node.label);
    }

    return exceptions;
  }

  /// Render all nodes on the canvas
  void render(Canvas canvas) {
    // First render the relationship nodes (lines)
    for (final node in _nodes) {
      if (node is LineNode) {
        node.render(canvas);
      }
    }

    // Then render the entity nodes (circles, rectangles, etc.)
    for (final node in _nodes) {
      if (node is! LineNode) {
        node.render(canvas);
      }
    }
  }

  /// Render the text for all nodes on the canvas
  void renderText(Canvas canvas) {
    // Render text for relationship nodes
    for (final node in _nodes) {
      if (node is LineNode) {
        node.renderText(canvas);
      }
    }

    // Render text for entity nodes
    for (final node in _nodes) {
      if (node is! LineNode) {
        node.renderText(canvas);
      }
    }
  }
}
