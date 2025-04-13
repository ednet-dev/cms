part of ednet_core_flutter;

/// Function type for building entity visualizations
typedef EntityVisualizationBuilder = Widget Function(
    List<Entity> entities, BuildContext context);

/// Visualizes domain models by aggregating multiple related entities
///
/// Implements the Aggregator pattern from Enterprise Integration Patterns
/// to collect related entities and display them together in a unified visualization.
class DomainModelVisualizer extends StatefulWidget {
  /// The correlation ID for grouping related entities
  final String correlationId;

  /// The build context for rendering widgets
  final BuildContext context;

  /// The collected entity messages
  final List<Message> _messages = [];

  /// The maximum waiting time for message collection
  final Duration timeout;

  /// The minimum number of messages required for completion
  final int minMessagesRequired;

  /// The current disclosure level
  final DisclosureLevel disclosureLevel;

  /// Callback for handling the visualization
  final EntityVisualizationBuilder? visualizationBuilder;

  /// Constructor
  DomainModelVisualizer({
    required this.correlationId,
    required this.context,
    this.timeout = const Duration(seconds: 5),
    this.minMessagesRequired = 1,
    this.disclosureLevel = DisclosureLevel.intermediate,
    this.visualizationBuilder,
    Key? key,
  }) : super(key: key);

  /// Add a message to the visualizer
  void addMessage(Message message) {
    _messages.add(message);
  }

  /// Create state
  @override
  State<DomainModelVisualizer> createState() => _DomainModelVisualizerState();

  /// Get messages
  List<Message> get messages => _messages;

  /// Check if there are enough messages
  bool get hasEnoughMessages => _messages.length >= minMessagesRequired;

  /// Get entities from messages
  List<Entity> get entities {
    return _messages
        .map((message) {
          final entityMap =
              message.metadata?['entity'] as Map<String, dynamic>?;
          if (entityMap == null) {
            return null;
          }

          final concept = message.metadata?['concept'] as Concept?;
          if (concept == null) {
            return null;
          }

          return concept.newEntity()..fromJsonMap(entityMap);
        })
        .whereType<Entity>()
        .toList();
  }

  /// Timestamp of when the entity was first created or added.
  Widget build(BuildContext context) {
    if (!hasEnoughMessages) {
      return const Center(child: CircularProgressIndicator());
    }

    final entities = this.entities;

    // Use custom builder if provided
    if (visualizationBuilder != null) {
      return visualizationBuilder!(entities, context);
    }

    // Default visualization
    return DefaultEntityVisualizer.buildVisualization(entities, context);
  }

  /// Create a visualizer for a single entity
  static DomainModelVisualizer forEntity({
    required String correlationId,
    required BuildContext context,
    required Entity entity,
    DisclosureLevel disclosureLevel = DisclosureLevel.intermediate,
  }) {
    // Create visualizer
    final visualizer = DomainModelVisualizer(
      correlationId: correlationId,
      context: context,
      disclosureLevel: disclosureLevel,
    );

    // Add message with entity
    final message = UXMessage(
      id: 'entity.visualize_${entity.id}',
      type: 'entity.visualize',
      payload: {'entity': entity.toJsonMap()},
      source: 'DomainModelVisualizer',
      metadata: {
        'correlationId': correlationId,
        'concept': entity.concept,
        'entity': entity.toJsonMap(),
      },
    );

    visualizer.addMessage(message);

    return visualizer;
  }

  /// Create a visualizer for an aggregate root and its children
  static DomainModelVisualizer forAggregate({
    required String correlationId,
    required BuildContext context,
    required Entity root,
    required List<Entity> children,
    DisclosureLevel disclosureLevel = DisclosureLevel.intermediate,
  }) {
    // Create visualizer
    final visualizer = DomainModelVisualizer(
      correlationId: correlationId,
      context: context,
      minMessagesRequired: 1 + children.length,
      disclosureLevel: disclosureLevel,
      visualizationBuilder: (entities, context) {
        // Use the static method directly
        return _AggregateVisualizer.buildVisualization(
            root, children, context, disclosureLevel);
      },
    );

    // Add root message
    visualizer.addMessage(
      UXMessage(
        id: 'entity.visualize.root_${root.id}',
        type: 'entity.visualize',
        payload: {'entity': root.toJsonMap(), 'isRoot': true},
        source: 'DomainModelVisualizer',
        metadata: {
          'correlationId': correlationId,
          'concept': root.concept,
          'entity': root.toJsonMap(),
        },
      ),
    );

    // Add child messages
    for (final child in children) {
      visualizer.addMessage(
        UXMessage(
          id: 'entity.visualize.child_${child.id}',
          type: 'entity.visualize',
          payload: {'entity': child.toJsonMap(), 'parentId': root.id},
          source: 'DomainModelVisualizer',
          metadata: {
            'correlationId': correlationId,
            'concept': child.concept,
            'entity': child.toJsonMap(),
          },
        ),
      );
    }

    return visualizer;
  }
}

/// State for the DomainModelVisualizer
class _DomainModelVisualizerState extends State<DomainModelVisualizer> {
  @override
  Widget build(BuildContext context) {
    if (!widget.hasEnoughMessages) {
      return const Center(child: CircularProgressIndicator());
    }

    final entities = widget.entities;

    // Use custom builder if provided
    if (widget.visualizationBuilder != null) {
      return widget.visualizationBuilder!(entities, context);
    }

    // Default visualization
    return DefaultEntityVisualizer.buildVisualization(entities, context);
  }
}

/// Default entity visualization helper
class DefaultEntityVisualizer {
  /// Build default visualization for entities
  static Widget buildVisualization(
      List<Entity> entities, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Domain Model Visualization',
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const SizedBox(height: 16),

        // Entity cards
        ...entities.map((entity) =>
            _buildEntityCard(entity, context, DisclosureLevel.intermediate)),

        // Empty state
        if (entities.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No entities found'),
            ),
          ),
      ],
    );
  }

  /// Build a card for an entity
  static Widget _buildEntityCard(
      Entity entity, BuildContext context, DisclosureLevel disclosureLevel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entity.concept.code}: ${entity.code}',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const Divider(),

            // Use adapter to visualize entity
            UXAdapterRegistry()
                .getAdapterByConceptCode(
                  entity,
                  disclosureLevel: disclosureLevel,
                )
                .buildVisualization(
                  context,
                  disclosureLevel: disclosureLevel,
                ),
          ],
        ),
      ),
    );
  }
}

/// Utility class for building aggregate visualizations
class _AggregateVisualizer {
  /// Build a visualization for an aggregate root and its children
  static Widget buildVisualization(
    Entity root,
    List<Entity> children,
    BuildContext context,
    DisclosureLevel disclosureLevel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Aggregate: ${root.concept.code}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const SizedBox(height: 8),

        // Root entity card
        Card(
          color: Colors.amber.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Root: ${root.code}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),

                const Divider(),

                // Root entity visualization using adapter
                UXAdapterRegistry()
                    .getAdapterByConceptCode(
                      root,
                      disclosureLevel: disclosureLevel,
                    )
                    .buildVisualization(
                      context,
                      disclosureLevel: disclosureLevel,
                    ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Children header
        Text(
          'Children (${children.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 8),

        // Child entities
        ...children.map(
          (child) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${child.concept.code}: ${child.code}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const Divider(),

                  // Child entity visualization using adapter
                  UXAdapterRegistry()
                      .getAdapterByConceptCode(
                        child,
                        disclosureLevel: disclosureLevel,
                      )
                      .buildVisualization(
                        context,
                        disclosureLevel: disclosureLevel,
                      ),
                ],
              ),
            ),
          ),
        ),

        // Empty state for no children
        if (children.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No child entities',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
      ],
    );
  }
}

/// Factory for creating domain model visualizers
class DomainModelVisualizerFactory {
  // Factory methods would go here
}
