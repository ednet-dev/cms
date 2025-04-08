part of ednet_core_flutter;

/// A custom painter for rendering domain models on a canvas.
///
/// This painter coordinates the rendering of domain models using the
/// visualization system, applying layout algorithms and visual decorations.
///
/// This is part of the EDNet Shell Architecture visualization system.
class MetaDomainPainter extends CustomPainter {
  /// The domain model to visualize
  final Domains domains;

  /// Controller for interactive transformations
  final TransformationController transformationController;

  /// The layout algorithm for positioning
  final LayoutAlgorithm layoutAlgorithm;

  /// Visual decorators to apply
  final List<UXDecorator> decorators;

  /// Whether user is currently dragging
  final bool isDragging;

  /// The visualization system for nodes and rendering
  final VisualizationSystem visualizationSystem;

  /// Current build context (for theming)
  final BuildContext context;

  /// ID of the selected node
  final String? selectedNode;

  /// Progressive disclosure level
  final DisclosureLevel disclosureLevel;

  /// Entity painter for rendering domain entities
  late final EntityPainter _entityPainter;

  /// Relation painter for rendering connections
  late final RelationPainter _relationPainter;

  /// Grid painter for rendering background grid
  late final GridPainter _gridPainter;

  /// Construct a domain model painter
  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
    required this.isDragging,
    required this.visualizationSystem,
    required this.context,
    this.selectedNode,
    this.disclosureLevel = DisclosureLevel.standard,
  }) {
    _entityPainter = EntityPainter(
      context: context,
      selectedNode: selectedNode,
      disclosureLevel: disclosureLevel,
    );

    _relationPainter = RelationPainter(
      context: context,
      disclosureLevel: disclosureLevel,
    );

    _gridPainter = GridPainter(
      disclosureLevel: disclosureLevel,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Apply decorators before rendering
    final decoratedCanvas = _applyDecorators(canvas, size);

    // Draw grid if disclosure level allows
    if (disclosureLevel.index >= DisclosureLevel.intermediate.index) {
      _gridPainter.paintGrid(decoratedCanvas, size);
    }

    // Calculate layout positions
    final positions = layoutAlgorithm.calculateLayout(domains, size);

    // Clear existing nodes
    visualizationSystem.clear();

    // Calculate max level for color gradations
    double maxLevel = _calculateMaxLevel(domains);

    // Create domain model visualization
    _createDomainVisualization(domains, positions, maxLevel);

    // Render the visualization using the visualization system
    visualizationSystem.render(decoratedCanvas);
    visualizationSystem.renderText(decoratedCanvas);
  }

  /// Calculate the maximum hierarchy level in the domain model
  double _calculateMaxLevel(Domains domains) {
    double maxLevel = 1.0;
    for (var domain in domains) {
      for (var model in domain.models) {
        for (var concept in model.concepts) {
          maxLevel = math.max(maxLevel, _getConceptLevel(concept, 1));
        }
      }
    }
    return maxLevel;
  }

  /// Get the nesting level of a concept
  double _getConceptLevel(Concept concept, double currentLevel) {
    double maxLevel = currentLevel;
    for (var child in concept.children) {
      maxLevel = math.max(maxLevel, _getChildLevel(child, currentLevel + 1));
    }
    return maxLevel;
  }

  /// Get the nesting level of a child property
  double _getChildLevel(Property child, double currentLevel) {
    double maxLevel = currentLevel;
    if (child is Child) {
      maxLevel = math.max(
        maxLevel,
        _getConceptLevel(child.destinationConcept, currentLevel + 1),
      );
    }
    return maxLevel;
  }

  /// Create visualization nodes for the domain model
  void _createDomainVisualization(
    Domains domains,
    Map<String, Offset> positions,
    double maxLevel,
  ) {
    // Create nodes for domains, models, concepts and their relationships
    // Only create visualizations appropriate for the current disclosure level
    for (var domain in domains) {
      final domainPosition = positions[domain.code];
      if (domainPosition == null) continue;

      // Add domain node with appropriate styling based on disclosure level
      _addDomainNode(domain, domainPosition, positions, 1, maxLevel);
    }
  }

  /// Add domain node and its children to the visualization
  void _addDomainNode(
    Domain domain,
    Offset domainPosition,
    Map<String, Offset> positions,
    int level,
    double maxLevel,
  ) {
    // Create domain node
    Color domainColor = _entityPainter.getColorForEntity(
      domain,
      level,
      maxLevel,
    );

    // Create visual node for domain
    VisualNode domainNode = _entityPainter.createVisualNode(
      domain,
      domainPosition,
      domainColor,
    );

    visualizationSystem.addNode(domainNode);

    // Only add models if disclosure level is sufficient
    if (disclosureLevel.index >= DisclosureLevel.basic.index) {
      _addModelNodes(domain, domainPosition, positions, level, maxLevel);
    }
  }

  /// Add model nodes for a domain
  void _addModelNodes(
    Domain domain,
    Offset domainPosition,
    Map<String, Offset> positions,
    int level,
    double maxLevel,
  ) {
    for (var model in domain.models) {
      final modelPosition = positions[model.code];
      if (modelPosition == null) continue;

      // Create model node
      Color modelColor = _entityPainter.getColorForEntity(
        model,
        level + 1,
        maxLevel,
      );

      // Create visual node for model
      VisualNode modelNode = _entityPainter.createVisualNode(
        model,
        modelPosition,
        modelColor,
      );

      visualizationSystem.addNode(modelNode);

      // Add relation from domain to model
      visualizationSystem.addNode(
        LineNode(
          start: domainPosition,
          end: modelPosition,
          sourceToTargetLabel: 'has',
          targetToSourceLabel: 'belongs to',
          color: Colors.grey,
        ),
      );

      // Only add concepts if disclosure level is sufficient
      if (disclosureLevel.index >= DisclosureLevel.standard.index) {
        _addConceptNodes(
            domain, model, modelPosition, positions, level, maxLevel);
      }
    }
  }

  /// Add concept nodes for a model
  void _addConceptNodes(
    Domain domain,
    Model model,
    Offset modelPosition,
    Map<String, Offset> positions,
    int level,
    double maxLevel,
  ) {
    // Implementation for adding concept nodes and their relationships
    // This would be expanded based on disclosure level
    for (var concept in model.concepts) {
      final conceptPosition = positions[concept.code];
      if (conceptPosition == null) continue;

      // Create concept node
      Color conceptColor = _entityPainter.getColorForEntity(
        concept,
        level + 2,
        maxLevel,
      );

      // Create visual node for concept
      VisualNode conceptNode = _entityPainter.createVisualNode(
        concept,
        conceptPosition,
        conceptColor,
      );

      visualizationSystem.addNode(conceptNode);

      // Add relation from model to concept
      visualizationSystem.addNode(
        LineNode(
          start: modelPosition,
          end: conceptPosition,
          sourceToTargetLabel: 'contains',
          targetToSourceLabel: 'is part of',
          color: Colors.grey,
        ),
      );
    }
  }

  /// Apply all decorators to the canvas
  Canvas _applyDecorators(Canvas canvas, Size size) {
    Canvas resultCanvas = canvas;

    // Apply each decorator in sequence
    for (final decorator in decorators) {
      resultCanvas = decorator.decorate(resultCanvas, size);
    }

    return resultCanvas;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always repaint if the delegate changed
    if (oldDelegate is! MetaDomainPainter) return true;

    final oldPainter = oldDelegate;

    // Repaint if any core property changed
    return oldPainter.isDragging != isDragging ||
        oldPainter.selectedNode != selectedNode ||
        oldPainter.domains != domains ||
        oldPainter.layoutAlgorithm != layoutAlgorithm ||
        oldPainter.transformationController != transformationController ||
        oldPainter.decorators.length != decorators.length ||
        oldPainter.visualizationSystem != visualizationSystem ||
        oldPainter.disclosureLevel != disclosureLevel;
  }
}
