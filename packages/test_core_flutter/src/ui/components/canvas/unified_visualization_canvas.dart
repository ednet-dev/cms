part of ednet_core_flutter;

/// A unified visualization canvas for domain model visualization.
///
/// This canvas integrates optimized algorithms for layout, rendering, and interaction,
/// providing a premium user experience for domain modeling.
///
/// Part of the EDNet Shell Architecture visualization system, this component serves
/// as the primary visualization surface for domain models.
class UnifiedVisualizationCanvas extends StatefulWidget {
  /// The domain models to visualize
  final Domains domains;

  /// The initial layout algorithm to use
  final LayoutAlgorithm layoutAlgorithm;

  /// Optional decorators for enhanced visualization
  final List<UXDecorator> decorators;

  /// Initial transformation matrix
  final Matrix4? initialTransformation;

  /// Callback when transformation changes
  final ValueChanged<Matrix4> onTransformationChanged;

  /// Callback when layout algorithm changes
  final ValueChanged<LayoutAlgorithm> onChangeLayoutAlgorithm;

  /// Disclosure level to control detail visibility
  final DisclosureLevel disclosureLevel;

  /// Debug mode flag
  final bool debugMode;

  /// Creates a new unified visualization canvas
  const UnifiedVisualizationCanvas({
    super.key,
    required this.domains,
    required this.layoutAlgorithm,
    this.decorators = const [],
    this.initialTransformation,
    required this.onTransformationChanged,
    required this.onChangeLayoutAlgorithm,
    this.disclosureLevel = DisclosureLevel.standard,
    this.debugMode = false,
  });

  @override
  UnifiedVisualizationCanvasState createState() =>
      UnifiedVisualizationCanvasState();
}

class UnifiedVisualizationCanvasState extends State<UnifiedVisualizationCanvas>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late LayoutAlgorithm _currentAlgorithm;
  late VisualizationSystem _visualizationSystem;
  late AnimationController _animationController;

  bool _isInitialLoad = true;
  String? _selectedNode;
  String? _hoveredNode;
  bool _isAnimating = false;

  // Visualization state
  late Map<String, Offset> _layoutPositions;
  final Map<String, EntityState> _entityStates = {};

  // Performance metrics
  int _lastFrameTime = 0;
  int _frameCount = 0;
  double _fps = 0;

  // Interaction handlers
  late PanHandler _panHandler;
  late ZoomHandler _zoomHandler;
  late SelectionHandler _selectionHandler;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize the visualization system (as an AggregateRoot in DDD terms)
    _visualizationSystem = VisualizationSystem();

    // Calculate initial layout
    _layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      const Size(1000, 1000), // Default size, will be updated in layout
    );

    // Initialize interaction handlers
    _panHandler = PanHandler(
      transformationController: _transformationController,
    );

    _zoomHandler = ZoomHandler(
      transformationController: _transformationController,
      onZoomLevelChanged: (zoom) => setState(() {}),
    );

    _selectionHandler = SelectionHandler(
      transformationController: _transformationController,
      onSelectionChanged: (nodeId) => setState(() {
        _selectedNode = nodeId;
        _triggerSelectionAnimation();
        _visualizationSystem.selectNode(nodeId);
      }),
    );

    // Listen for animation status
    _animationController.addStatusListener(_handleAnimationStatus);

    // Apply initial transformation if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInitialLoad && mounted) {
        if (widget.initialTransformation != null) {
          _transformationController.value = widget.initialTransformation!;
          _zoomHandler.zoomLevel =
              _transformationController.value.getMaxScaleOnAxis();
        } else {
          _centerAndZoomSafely();
        }
        _isInitialLoad = false;
        _updateVisualization();
      }
    });

    // Listen for transformation changes
    _transformationController.addListener(() {
      widget.onTransformationChanged(_transformationController.value);
      _updateVisibleNodesSafely();
    });
  }

  @override
  void didUpdateWidget(UnifiedVisualizationCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle changes to domains
    if (widget.domains != oldWidget.domains) {
      _recalculateLayout();
    }

    // Handle changes to layout algorithm
    if (widget.layoutAlgorithm != oldWidget.layoutAlgorithm) {
      _currentAlgorithm = widget.layoutAlgorithm;
      _recalculateLayout();
    }

    // Handle changes to disclosure level
    if (widget.disclosureLevel != oldWidget.disclosureLevel) {
      _updateVisualization();
    }
  }

  /// Recalculates the layout with the current algorithm
  void _recalculateLayout() {
    final BuildContext? currentContext = context;
    if (currentContext == null) return;

    final Size size = currentContext.size ?? const Size(1000, 1000);

    _layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      size,
    );

    _updateVisualization();
    setState(() {});
  }

  /// Updates the visualization with current data and settings
  void _updateVisualization() {
    // Clear the visualization system
    _visualizationSystem.clear();

    // Create visual nodes based on the current domain model and layout
    _createDomainModelNodes(widget.domains, _layoutPositions);

    // Re-select the currently selected node if any
    if (_selectedNode != null) {
      _visualizationSystem.selectNode(_selectedNode);
    }
  }

  /// Creates domain model nodes from the domains data
  void _createDomainModelNodes(Domains domains, Map<String, Offset> positions) {
    // Calculate the maximum depth for color gradients
    int maxLevel = _calculateMaxDepth(domains);

    // Create nodes for domains
    for (final domain in domains) {
      _createDomainNode(domain, positions, 1, maxLevel);
    }
  }

  /// Calculate the maximum depth of the domain model
  int _calculateMaxDepth(Domains domains) {
    int maxDepth = 1;

    // Apply disclosure level limits
    int maxAllowedDepth;
    switch (widget.disclosureLevel) {
      case DisclosureLevel.minimal:
        maxAllowedDepth = 2; // Only domains and models
        break;
      case DisclosureLevel.basic:
        maxAllowedDepth = 3; // Domains, models, and concepts
        break;
      case DisclosureLevel.standard:
        maxAllowedDepth = 4; // Include properties
        break;
      case DisclosureLevel.advanced:
        maxAllowedDepth = 5; // Include deeper relationships
        break;
      case DisclosureLevel.complete:
        maxAllowedDepth = 10; // No practical limit
        break;
      default:
        maxAllowedDepth = 4;
    }

    // Calculate actual depth based on the domain model
    for (final domain in domains) {
      for (final model in domain.models) {
        for (final concept in model.concepts) {
          maxDepth = math.max(maxDepth, _getConceptDepth(concept, 1));
        }
      }
    }

    // Apply the disclosure level limit
    return math.min(maxDepth, maxAllowedDepth);
  }

  /// Get the depth of a concept in the hierarchy
  int _getConceptDepth(Concept concept, int currentDepth) {
    int maxDepth = currentDepth;

    for (final child in concept.children) {
      maxDepth = math.max(maxDepth, _getChildDepth(child, currentDepth + 1));
    }

    return maxDepth;
  }

  /// Get the depth of a child property
  int _getChildDepth(Property child, int currentDepth) {
    int maxDepth = currentDepth;

    if (child is Child) {
      maxDepth = math.max(
        maxDepth,
        _getConceptDepth(child.destinationConcept, currentDepth + 1),
      );
    }

    return maxDepth;
  }

  /// Create visual nodes for a domain and its children
  void _createDomainNode(
      Domain domain, Map<String, Offset> positions, int level, int maxLevel) {
    // Skip if we're beyond the disclosure level's depth
    if (level > _getMaxLevelForDisclosure(widget.disclosureLevel)) {
      return;
    }

    final domainPosition = positions[domain.code];
    if (domainPosition == null) return;

    // Create node for the domain
    final domainColor = _getColorForLevel(level, maxLevel);
    final domainNode = VisualNode(
      position: domainPosition,
      color: domainColor,
      type: 'domain',
      label: domain.code,
      size: _getSizeForLevel(level, widget.disclosureLevel),
    );

    _visualizationSystem.addNode(domainNode);

    // Create nodes for models
    for (final model in domain.models) {
      // Skip if beyond disclosure level
      if (level + 1 > _getMaxLevelForDisclosure(widget.disclosureLevel)) {
        continue;
      }

      final modelPosition = positions[model.code];
      if (modelPosition == null) continue;

      // Create node for the model
      final modelColor = _getColorForLevel(level + 1, maxLevel);
      final modelNode = VisualNode(
        position: modelPosition,
        color: modelColor,
        type: 'model',
        label: model.code,
        size: _getSizeForLevel(level + 1, widget.disclosureLevel),
      );

      _visualizationSystem.addNode(modelNode);

      // Create connection between domain and model
      _visualizationSystem.addNode(
        LineNode(
          start: domainPosition,
          end: modelPosition,
          sourceToTargetLabel: 'has',
          targetToSourceLabel: 'belongs to',
          color: Colors.grey,
        ),
      );

      // Create nodes for concepts
      for (final concept in model.concepts) {
        // Skip if beyond disclosure level
        if (level + 2 > _getMaxLevelForDisclosure(widget.disclosureLevel)) {
          continue;
        }

        final conceptPosition = positions[concept.code];
        if (conceptPosition == null) continue;

        // Create node for the concept
        final conceptColor = _getColorForLevel(level + 2, maxLevel);
        final conceptNode = VisualNode(
          position: conceptPosition,
          color: conceptColor,
          type: 'concept',
          label: concept.code,
          size: _getSizeForLevel(level + 2, widget.disclosureLevel),
        );

        _visualizationSystem.addNode(conceptNode);

        // Create connection between model and concept
        _visualizationSystem.addNode(
          LineNode(
            start: modelPosition,
            end: conceptPosition,
            sourceToTargetLabel: 'contains',
            targetToSourceLabel: 'is part of',
            color: Colors.grey,
          ),
        );

        // Only proceed with children and parent relationships if disclosure level permits
        if (widget.disclosureLevel.index >= DisclosureLevel.standard.index) {
          // Create nodes for concept children
          _createConceptChildrenNodes(
              concept, conceptPosition, positions, level + 3, maxLevel);

          // Create connections for parent-child relationships
          _createConceptParentNodes(
              concept, conceptPosition, positions, level + 3, maxLevel);
        }
      }
    }
  }

  /// Create nodes for concept children
  void _createConceptChildrenNodes(Concept concept, Offset conceptPosition,
      Map<String, Offset> positions, int level, int maxLevel) {
    // Skip if beyond disclosure level
    if (level > _getMaxLevelForDisclosure(widget.disclosureLevel)) {
      return;
    }

    for (final child in concept.children) {
      final childPosition = positions[child.code];
      if (childPosition == null) continue;

      // Create node for the child
      final childColor = _getColorForLevel(level, maxLevel);
      final childNode = VisualNode(
        position: childPosition,
        color: childColor,
        type: 'property',
        label: child.code,
        size: _getSizeForLevel(level, widget.disclosureLevel),
      );

      _visualizationSystem.addNode(childNode);

      // Create connection between concept and child
      _visualizationSystem.addNode(
        LineNode(
          start: conceptPosition,
          end: childPosition,
          sourceToTargetLabel: child.code,
          targetToSourceLabel: (child as Neighbor).sourceConcept.code,
          color: Colors.grey,
        ),
      );
    }
  }

  /// Create nodes for concept parents
  void _createConceptParentNodes(Concept concept, Offset conceptPosition,
      Map<String, Offset> positions, int level, int maxLevel) {
    // Skip if beyond disclosure level
    if (level > _getMaxLevelForDisclosure(widget.disclosureLevel)) {
      return;
    }

    for (final parent in concept.parents) {
      final parentPosition = positions[parent.code];
      if (parentPosition != null) {
        _visualizationSystem.addNode(
          LineNode(
            start: parentPosition,
            end: conceptPosition,
            sourceToTargetLabel: parent.code,
            targetToSourceLabel: parent.sourceConcept.code,
            color: Colors.grey,
          ),
        );
      }
    }
  }

  /// Get the maximum level to show based on disclosure level
  int _getMaxLevelForDisclosure(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
        return 2; // Only domains and models
      case DisclosureLevel.basic:
        return 3; // Domains, models, concepts
      case DisclosureLevel.standard:
        return 4; // Include properties
      case DisclosureLevel.intermediate:
        return 5; // Include more detailed relationships
      case DisclosureLevel.advanced:
        return 6; // Include deeper relationships
      case DisclosureLevel.detailed:
        return 8; // Include most details
      case DisclosureLevel.complete:
        return 10; // No practical limit
      case DisclosureLevel.debug:
        return 12; // Everything, including debug info
    }
  }

  /// Get size based on level and disclosure setting
  double _getSizeForLevel(int level, DisclosureLevel disclosureLevel) {
    // Base sizes for each level
    final Map<int, double> baseSizes = {
      1: 60.0, // Domain
      2: 50.0, // Model
      3: 40.0, // Concept
      4: 30.0, // Property
      5: 25.0, // Nested Property
    };

    // Default to smaller size for deeper levels
    double baseSize = baseSizes[level] ?? 20.0;

    // Adjust size based on disclosure level
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        return baseSize * 0.8;
      case DisclosureLevel.basic:
        return baseSize * 0.9;
      case DisclosureLevel.standard:
        return baseSize;
      case DisclosureLevel.intermediate:
        return baseSize * 1.05;
      case DisclosureLevel.advanced:
        return baseSize * 1.1;
      case DisclosureLevel.detailed:
        return baseSize * 1.15;
      case DisclosureLevel.complete:
        return baseSize * 1.2;
      case DisclosureLevel.debug:
        return baseSize * 1.3;
    }
  }

  /// Changes the current layout algorithm
  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _currentAlgorithm = algorithm;
      widget.onChangeLayoutAlgorithm(algorithm);
      _recalculateLayout();
      _animateLayoutTransition();
    });
  }

  /// Centers and zooms the view to fit all entities
  void _centerAndZoom() {
    if (!mounted) return;

    final BuildContext? currentContext = context;
    if (currentContext == null) return;

    final RenderBox? renderBox =
        currentContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final Size canvasSize = renderBox.size;
    if (canvasSize.isEmpty) return;

    _zoomHandler.centerAndZoom(canvasSize, _layoutPositions);
  }

  /// Safely calls center and zoom with null checks
  void _centerAndZoomSafely() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _centerAndZoom();
    });
  }

  /// Updates the entity states for nodes in the visible area
  void _updateVisibleNodes() {
    if (!mounted) return;

    final BuildContext? currentContext = context;
    if (currentContext == null) return;

    final RenderBox? renderBox =
        currentContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final Size size = renderBox.size;
    if (size.isEmpty) return;

    // Calculate the visible area in scene coordinates
    final topLeft = _transformationController.toScene(Offset.zero);
    final bottomRight = _transformationController.toScene(
      Offset(size.width, size.height),
    );
    final visibleRect = Rect.fromPoints(topLeft, bottomRight);

    // Update entity states for nodes in visible rect
    // (This is a simplified version that doesn't use a spatial index yet)
    for (var entry in _layoutPositions.entries) {
      final nodeId = entry.key;
      final position = entry.value;
      final isVisible = visibleRect.contains(position);

      if (!_entityStates.containsKey(nodeId)) {
        _entityStates[nodeId] = EntityState(
          position: position,
          visible: isVisible,
          selected: nodeId == _selectedNode,
          hovered: nodeId == _hoveredNode,
        );
      } else {
        _entityStates[nodeId]!.visible = isVisible;
        _entityStates[nodeId]!.position = position;
        _entityStates[nodeId]!.selected = nodeId == _selectedNode;
        _entityStates[nodeId]!.hovered = nodeId == _hoveredNode;
      }
    }
  }

  /// Safely calls updateVisibleNodes with proper null checks
  void _updateVisibleNodesSafely() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateVisibleNodes();
    });
  }

  /// Get a color for a specific level in the hierarchy
  Color _getColorForLevel(int level, int maxLevel) {
    // Use a hue-based gradient for different levels
    final double hue = (level / (maxLevel + 1)) * 360;
    return HSVColor.fromAHSV(
      1.0,
      hue,
      0.7,
      0.9,
    ).toColor();
  }

  /// Handles tap events on the canvas
  void _handleTap(TapUpDetails details) {
    _selectionHandler.handleTap(details, context, _layoutPositions);
  }

  /// Handles hover events on the canvas
  void _handleHover(PointerHoverEvent event) {
    final BuildContext? currentContext = context;
    if (currentContext == null) return;

    final RenderBox? renderBox =
        currentContext.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(event.position);

    // Find the node under the pointer
    String? hoveredNodeId = null;

    // Convert screen position to scene coordinates
    final scenePoint = _transformationController.toScene(localPosition);

    // Find which node contains this point (if any)
    for (var entry in _layoutPositions.entries) {
      final nodeId = entry.key;
      final nodePos = entry.value;

      // Simple circle hit test - can be refined based on actual node shapes
      final nodeSize = _getSizeForLevel(
        _getNodeLevel(nodeId),
        widget.disclosureLevel,
      );

      if ((nodePos - scenePoint).distance <= nodeSize / 2) {
        hoveredNodeId = nodeId;
        break;
      }
    }

    if (_hoveredNode != hoveredNodeId) {
      setState(() => _hoveredNode = hoveredNodeId);
    }
  }

  /// Get the level of a node based on its ID or type
  int _getNodeLevel(String nodeId) {
    // Determine level based on node type
    if (nodeId.startsWith('Domain')) return 1;
    if (nodeId.startsWith('Model')) return 2;
    if (nodeId.startsWith('Concept')) return 3;
    return 4; // Property
  }

  /// Triggers the selection animation
  void _triggerSelectionAnimation() {
    setState(() => _isAnimating = true);
    _animationController.forward(from: 0.0);
  }

  /// Handles animation status changes
  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() => _isAnimating = false);
    }
  }

  /// Animates the transition between layout algorithms
  void _animateLayoutTransition() {
    setState(() => _isAnimating = true);
    _animationController.forward(from: 0.0);
  }

  /// Updates performance metrics
  void _updatePerformanceMetrics() {
    if (!widget.debugMode) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    _frameCount++;

    if (now - _lastFrameTime > 1000) {
      setState(() {
        _fps = _frameCount * 1000 / (now - _lastFrameTime);
        _frameCount = 0;
        _lastFrameTime = now;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update performance metrics in debug mode
    if (widget.debugMode) {
      _updatePerformanceMetrics();
    }

    return Stack(
      children: [
        Column(
          children: [
            // Algorithm selector
            if (widget.disclosureLevel.index >= DisclosureLevel.basic.index)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LayoutAlgorithmIcon(
                      icon: Icons.auto_fix_high,
                      name: 'Force Directed',
                      onTap: () => _changeLayoutAlgorithm(
                        ForceDirectedLayoutAlgorithm(),
                      ),
                      isActive:
                          _currentAlgorithm is ForceDirectedLayoutAlgorithm,
                      disclosureLevel: widget.disclosureLevel,
                    ),
                    LayoutAlgorithmIcon(
                      icon: Icons.grid_on,
                      name: 'Grid',
                      onTap: () =>
                          _changeLayoutAlgorithm(GridLayoutAlgorithm()),
                      isActive: _currentAlgorithm is GridLayoutAlgorithm,
                      disclosureLevel: widget.disclosureLevel,
                    ),
                    LayoutAlgorithmIcon(
                      icon: Icons.circle,
                      name: 'Circular',
                      onTap: () =>
                          _changeLayoutAlgorithm(CircularLayoutAlgorithm()),
                      isActive: _currentAlgorithm is CircularLayoutAlgorithm,
                      disclosureLevel: widget.disclosureLevel,
                    ),
                    if (widget.disclosureLevel.index >=
                        DisclosureLevel.advanced.index) ...[
                      LayoutAlgorithmIcon(
                        icon: Icons.format_indent_increase,
                        name: 'Master Detail',
                        onTap: () => _changeLayoutAlgorithm(
                            MasterDetailLayoutAlgorithm()),
                        isActive:
                            _currentAlgorithm is MasterDetailLayoutAlgorithm,
                        disclosureLevel: widget.disclosureLevel,
                      ),
                      LayoutAlgorithmIcon(
                        icon: Icons.account_tree,
                        name: 'Ranked Tree',
                        onTap: () => _changeLayoutAlgorithm(
                          RankedEmbeddingLayoutAlgorithm(),
                        ),
                        isActive:
                            _currentAlgorithm is RankedEmbeddingLayoutAlgorithm,
                        disclosureLevel: widget.disclosureLevel,
                      ),
                    ],
                  ],
                ),
              ),

            // Canvas area
            Expanded(
              child: Listener(
                onPointerHover: widget.disclosureLevel.index >=
                        DisclosureLevel.standard.index
                    ? _handleHover
                    : null,
                child: GestureDetector(
                  onScaleStart: _panHandler.onPanStart,
                  onScaleEnd: _panHandler.onPanEnd,
                  onTapUp: _handleTap,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    onInteractionUpdate: (details) {
                      // Handle pan and zoom updates
                      _panHandler.onPanUpdate(details);
                      _zoomHandler.onZoomUpdate(details);
                    },
                    minScale: 0.1,
                    maxScale: 5.0,
                    child: CustomPaint(
                      painter: MetaDomainPainter(
                        domains: widget.domains,
                        transformationController: _transformationController,
                        layoutAlgorithm: _currentAlgorithm,
                        decorators: widget.decorators,
                        isDragging: _panHandler.isDragging,
                        visualizationSystem: _visualizationSystem,
                        context: context,
                        selectedNode: _selectedNode,
                      ),
                      child: Container(), // Provide a surface to paint on
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Zoom controls
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Zoom controls vary based on disclosure level
              if (widget.disclosureLevel.index >= DisclosureLevel.basic.index)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      onPressed: () => _zoomHandler.zoom(1.1),
                      tooltip: 'Zoom in',
                      heroTag: 'zoom_in',
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 8.0),
                    FloatingActionButton.small(
                      onPressed: () => _zoomHandler.zoom(0.9),
                      tooltip: 'Zoom out',
                      heroTag: 'zoom_out',
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              const SizedBox(height: 8.0),
              FloatingActionButton.small(
                onPressed: _centerAndZoom,
                tooltip: 'Center view',
                heroTag: 'center',
                child: const Icon(Icons.center_focus_strong),
              ),
              if (widget.debugMode)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Zoom: ${(_zoomHandler.zoomLevel * 100).toInt()}%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'FPS: ${_fps.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Nodes: ${_visualizationSystem.nodes.length}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

/// Entity state for tracking node properties
class EntityState {
  /// Position of the entity
  Offset position;

  /// Whether the entity is visible in the current view
  bool visible;

  /// Whether the entity is selected
  bool selected;

  /// Whether the entity is being hovered over
  bool hovered;

  /// Create a new entity state
  EntityState({
    required this.position,
    this.visible = true,
    this.selected = false,
    this.hovered = false,
  });
}
