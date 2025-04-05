// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;

/// A layout manager for domain model graphs.
///
/// This class provides a bridge between EDNet Core domain models and
/// the GraphView visualization library. It handles the creation of
/// nodes and edges, layout calculation, and styling.
class GraphLayout {
  /// The domains to visualize.
  final Domains domains;

  /// Default width for graph nodes.
  final double defaultNodeWidth;

  /// Default height for graph nodes.
  final double defaultNodeHeight;

  /// Creates a new graph layout for the given domains.
  ///
  /// Parameters:
  /// - [domains]: The domains to visualize
  /// - [defaultNodeWidth]: Default width for nodes (defaults to 150)
  /// - [defaultNodeHeight]: Default height for nodes (defaults to 80)
  GraphLayout({
    required this.domains,
    this.defaultNodeWidth = 150,
    this.defaultNodeHeight = 80,
  });

  /// Builds a GraphView-compatible graph from the domains.
  ///
  /// This method creates a hierarchical graph structure representing the
  /// domain model structure, where domains contain models, models contain
  /// entities (concepts), etc.
  gv.Graph buildGraph() {
    final graph = gv.Graph();

    // A map to keep track of created nodes by their ID
    final nodeMap = <String, gv.Node>{};

    // Process each domain
    for (var domain in domains) {
      // Create domain node
      final domainNode = gv.Node.Id(domain.code);
      graph.addNode(domainNode);
      nodeMap[domain.code] = domainNode;

      // Process each model in the domain
      for (var model in domain.models) {
        // Create model node
        final modelNode = gv.Node.Id(model.code);
        graph.addNode(modelNode);
        nodeMap[model.code] = modelNode;

        // Connect domain to model
        graph.addEdge(nodeMap[domain.code]!, modelNode);

        // Process each concept (entity) in the model
        for (var concept in model.concepts) {
          // Create concept node
          final conceptNode = gv.Node.Id(concept.code);
          graph.addNode(conceptNode);
          nodeMap[concept.code] = conceptNode;

          // Connect model to concept
          graph.addEdge(nodeMap[model.code]!, conceptNode);

          // Process each attribute in the concept
          for (var attribute in concept.attributes) {
            // Create attribute node with a unique ID
            final attributeId = '${concept.code}_${attribute.code}';
            final attributeNode = gv.Node.Id(attributeId);
            graph.addNode(attributeNode);
            nodeMap[attributeId] = attributeNode;

            // Connect concept to attribute
            graph.addEdge(nodeMap[concept.code]!, attributeNode);
          }
        }
      }
    }

    return graph;
  }

  /// Creates a widget for displaying a node in the graph.
  ///
  /// This method provides styled containers for visualizing graph nodes.
  /// Different node types (domains, models, concepts) get different styling.
  Widget createNodeWidget(
    String nodeText, {
    Color? color,
    double? width,
    double? height,
  }) {
    // Identify node type from its text to apply appropriate styling
    final isEntity = domains.any(
      (domain) => domain.models.any(
        (model) => model.concepts.any((concept) => concept.code == nodeText),
      ),
    );

    final isModel = domains.any(
      (domain) => domain.models.any((model) => model.code == nodeText),
    );

    final isDomain = domains.any((domain) => domain.code == nodeText);

    // Default color is blue, but we'll use different colors for different node types
    Color nodeColor;
    if (isDomain) {
      nodeColor = color ?? const Color(0xFFE3F2FD); // Light blue for domains
    } else if (isModel) {
      nodeColor = color ?? const Color(0xFFEFEBE9); // Beige for models
    } else if (isEntity) {
      nodeColor = color ?? const Color(0xFFE8F5E9); // Light green for entities
    } else {
      nodeColor =
          color ?? const Color(0xFFF5F5F5); // Light grey for other nodes
    }

    return Container(
      width: width ?? defaultNodeWidth,
      height: height ?? defaultNodeHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: nodeColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          nodeText,
          style: TextStyle(
            fontSize: 14,
            fontWeight:
                isDomain || isModel ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }

  /// Checks if the graph contains cycles.
  ///
  /// Uses depth-first search to detect cycles in the graph.
  /// Returns true if a cycle is detected, false otherwise.
  bool checkForCycles(gv.Graph graph) {
    final visited = <gv.Node>{};
    final stack = <gv.Node>{};

    bool hasCycle(gv.Node node) {
      if (stack.contains(node)) return true;
      if (visited.contains(node)) return false;
      visited.add(node);
      stack.add(node);

      for (final neighbor in graph.successorsOf(node)) {
        if (hasCycle(neighbor)) return true;
      }
      stack.remove(node);
      return false;
    }

    for (final node in graph.nodes) {
      if (hasCycle(node)) {
        return true;
      }
    }
    return false;
  }
}
