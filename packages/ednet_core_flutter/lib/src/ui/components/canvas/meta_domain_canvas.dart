part of ednet_core_flutter;

/// A canvas widget for visualizing domain models.
///
/// This widget handles the rendering and interactions for domain model visualization,
/// allowing users to view, navigate, and interact with domain entities and relationships.
///
/// This is part of the EDNet Shell Architecture visualization system.
class MetaDomainCanvas extends StatefulWidget {
  /// The domain model to visualize
  final Domains domains;

  /// The layout algorithm to use for positioning entities
  final LayoutAlgorithm layoutAlgorithm;

  /// Visual decorators to apply to the domain model elements
  final List<UXDecorator> decorators;

  /// Initial transformation matrix (for zoom/pan state)
  final Matrix4? initialTransformation;

  /// Callback when the transformation changes (zoom/pan)
  final ValueChanged<Matrix4> onTransformationChanged;

  /// Callback when the layout algorithm changes
  final ValueChanged<LayoutAlgorithm> onChangeLayoutAlgorithm;

  /// Progressive disclosure level to control detail
  final DisclosureLevel disclosureLevel;

  /// Creates a new domain model visualization canvas
  const MetaDomainCanvas({
    super.key,
    required this.domains,
    required this.layoutAlgorithm,
    required this.decorators,
    this.initialTransformation,
    required this.onTransformationChanged,
    required this.onChangeLayoutAlgorithm,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  @override
  MetaDomainCanvasState createState() => MetaDomainCanvasState();
}

/// State for the MetaDomainCanvas widget
class MetaDomainCanvasState extends State<MetaDomainCanvas> {
  /// Transformation controller for zoom/pan
  late TransformationController _transformationController;

  /// Current layout algorithm
  late LayoutAlgorithm _currentAlgorithm;

  /// Engine for animations and rendering
  late VisualizationSystem _visualizationSystem;

  /// First render flag
  bool _isInitialLoad = true;

  /// Currently selected node
  String? _selectedNode;

  /// Interaction handlers
  late PanHandler _panHandler;
  late ZoomHandler _zoomHandler;
  late SelectionHandler _selectionHandler;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
    _visualizationSystem = VisualizationSystem();

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
        _visualizationSystem.selectNode(nodeId);
      }),
    );

    // Initial setup after first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInitialLoad) {
        if (widget.initialTransformation != null) {
          _transformationController.value = widget.initialTransformation!;
          setState(() {
            _zoomHandler.zoomLevel =
                _transformationController.value.getMaxScaleOnAxis();
          });
        } else {
          _centerAndZoom();
        }
        _isInitialLoad = false;
      }
    });

    // Listen for transformation changes
    _transformationController.addListener(() {
      widget.onTransformationChanged(_transformationController.value);
    });
  }

  /// Updates the layout algorithm
  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _currentAlgorithm = algorithm;
      // Notify parent about the change
      widget.onChangeLayoutAlgorithm(algorithm);
      // Refresh the visualization
      _updateVisualization();
    });
  }

  /// Centers and zooms the visualization
  void _centerAndZoom() {
    final renderBox = context.findRenderObject() as RenderBox;
    final canvasSize = renderBox.size;
    final layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      canvasSize,
    );

    _zoomHandler.centerAndZoom(canvasSize, layoutPositions);
  }

  /// Handles tap interactions
  void _handleTap(TapUpDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      renderBox.size,
    );

    _selectionHandler.handleTap(details, context, layoutPositions);
  }

  /// Updates the visualization system with the current domain model
  void _updateVisualization() {
    // Clear existing nodes
    _visualizationSystem.clear();

    // Get layout positions
    final renderBox = context.findRenderObject() as RenderBox;

    final canvasSize = renderBox.size;
    final layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      canvasSize,
    );

    // Create visual nodes
    _createDomainModelNodes(widget.domains, layoutPositions);

    // Re-select the currently selected node if any
    if (_selectedNode != null) {
      _visualizationSystem.selectNode(_selectedNode);
    }
  }

  /// Creates visual nodes for the domain model
  void _createDomainModelNodes(Domains domains, Map<String, Offset> positions) {
    // Calculate the maximum depth for color gradients
    final maxLevel = _calculateMaxDepth(domains);

    // Create nodes for each domain element
    for (final domain in domains) {
      _createDomainNode(domain, positions, 1, maxLevel);
    }
  }

  /// Calculate the maximum nesting depth in the domain model
  int _calculateMaxDepth(Domains domains) {
    var maxDepth = 1;

    for (final domain in domains) {
      for (final model in domain.models) {
        for (final concept in model.concepts) {
          maxDepth = math.max(maxDepth, _getConceptDepth(concept, 1));
        }
      }
    }

    return maxDepth;
  }

  /// Get the depth of a concept in the model
  int _getConceptDepth(Concept concept, int currentDepth) {
    var maxDepth = currentDepth;

    for (final child in concept.children) {
      maxDepth = math.max(maxDepth, _getChildDepth(child, currentDepth + 1));
    }

    return maxDepth;
  }

  /// Get the depth of a child property
  int _getChildDepth(Property child, int currentDepth) {
    var maxDepth = currentDepth;

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
    final domainPosition = positions[domain.code];
    if (domainPosition == null) return;

    // Create node for the domain
    final domainColor = _getColorForLevel(level, maxLevel);
    final domainNode = VisualNode(
      position: domainPosition,
      color: domainColor,
      type: 'domain',
      label: domain.code,
      size: 60.0,
    );

    _visualizationSystem.addNode(domainNode);

    // Create nodes for models
    for (final model in domain.models) {
      final modelPosition = positions[model.code];
      if (modelPosition == null) continue;

      // Create node for the model
      final modelColor = _getColorForLevel(level + 1, maxLevel);
      final modelNode = VisualNode(
        position: modelPosition,
        color: modelColor,
        type: 'model',
        label: model.code,
        size: 50.0,
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
        final conceptPosition = positions[concept.code];
        if (conceptPosition == null) continue;

        // Create node for the concept
        final conceptColor = _getColorForLevel(level + 2, maxLevel);
        final conceptNode = VisualNode(
          position: conceptPosition,
          color: conceptColor,
          type: 'concept',
          label: concept.code,
          size: 40.0,
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

        // Create nodes for concept children
        for (final child in concept.children) {
          final childPosition = positions[child.code];
          if (childPosition == null) continue;

          // Create node for the child
          final childColor = _getColorForLevel(level + 3, maxLevel);
          final childNode = VisualNode(
            position: childPosition,
            color: childColor,
            type: 'property',
            label: child.code,
            size: 30.0,
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

        // Create connections for parent-child relationships
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
    }
  }

  /// Get a color for a specific level in the hierarchy
  Color _getColorForLevel(int level, int maxLevel) {
    // Use a hue-based gradient for different levels
    final hue = (level / (maxLevel + 1)) * 360;
    return HSVColor.fromAHSV(
      1.0,
      hue,
      0.7,
      0.9,
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    // If first render, update the visualization
    if (_isInitialLoad) {
      // Delay until after render when we have size
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateVisualization();
      });
    }

    return Stack(
      children: [
        Column(
          children: [
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
                    isActive: _currentAlgorithm is ForceDirectedLayoutAlgorithm,
                    disclosureLevel: widget.disclosureLevel,
                  ),
                  LayoutAlgorithmIcon(
                    icon: Icons.grid_on,
                    name: 'Grid',
                    onTap: () => _changeLayoutAlgorithm(GridLayoutAlgorithm()),
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
                  LayoutAlgorithmIcon(
                    icon: Icons.format_indent_increase,
                    name: 'Master Detail',
                    onTap: () =>
                        _changeLayoutAlgorithm(MasterDetailLayoutAlgorithm()),
                    isActive: _currentAlgorithm is MasterDetailLayoutAlgorithm,
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
              ),
            ),
            Expanded(
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
              if (widget.disclosureLevel.index >=
                  DisclosureLevel.standard.index)
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
              if (widget.disclosureLevel.index >=
                  DisclosureLevel.advanced.index)
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
                    child: Text(
                      'Zoom: ${(_zoomHandler.zoomLevel * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall,
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
    super.dispose();
  }
}
