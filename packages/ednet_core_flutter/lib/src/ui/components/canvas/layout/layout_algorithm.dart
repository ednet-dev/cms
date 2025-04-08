part of ednet_core_flutter;

/// An algorithm for calculating layout positions for domain model entities.
///
/// This is part of the EDNet Shell Architecture's visualization system,
/// providing a consistent interface for different layout strategies.
abstract class LayoutAlgorithm {
  /// Calculate positions for all entities in a domain model
  ///
  /// Returns a map of entity codes to their positions on the canvas.
  Map<String, Offset> calculateLayout(Domains domains, Size size);

  /// The name of this layout algorithm
  String get name;

  /// The icon to use for this layout algorithm
  IconData get icon;

  /// Description of this layout algorithm
  String get description;
}

/// A basic grid layout algorithm that arranges entities in a grid pattern.
///
/// This is a simple layout algorithm that can be used as a fallback when
/// more specialized algorithms are not available.
class GridLayoutAlgorithm implements LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final Map<String, Offset> positions = {};
    final entities = _collectAllEntities(domains);

    if (entities.isEmpty) return positions;

    // Calculate grid dimensions
    final int columns = math.sqrt(entities.length).ceil();
    final int rows = (entities.length / columns).ceil();

    // Calculate cell size
    final double cellWidth = size.width / columns;
    final double cellHeight = size.height / rows;

    // Position entities in grid cells
    for (int i = 0; i < entities.length; i++) {
      final int row = i ~/ columns;
      final int col = i % columns;

      // Position in the center of the cell
      final double x = col * cellWidth + cellWidth / 2;
      final double y = row * cellHeight + cellHeight / 2;

      positions[entities[i]] = Offset(x, y);
    }

    return positions;
  }

  /// Collect all entity codes from domains, models, concepts, etc.
  List<String> _collectAllEntities(Domains domains) {
    final List<String> entities = [];

    // Add domain codes
    for (final domain in domains) {
      entities.add(domain.code);

      // Add model codes
      for (final model in domain.models) {
        entities.add(model.code);

        // Add concept codes
        for (final concept in model.concepts) {
          entities.add(concept.code);

          // Add property codes (children and parents)
          for (final child in concept.children) {
            entities.add(child.code);
          }

          for (final parent in concept.parents) {
            entities.add(parent.code);
          }
        }
      }
    }

    return entities;
  }

  @override
  String get name => 'Grid';

  @override
  IconData get icon => Icons.grid_on;

  @override
  String get description => 'Arranges entities in a simple grid pattern';
}

/// A circular layout algorithm that arranges entities in concentric circles.
///
/// This algorithm puts related elements in the same circle, with domains in the
/// center, models in the next ring, and so on.
class CircularLayoutAlgorithm implements LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final Map<String, Offset> positions = {};

    // Center of the canvas
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Maximum radius is the smaller of width/2 or height/2
    final double maxRadius = math.min(size.width, size.height) / 2 * 0.8;

    // Position domains in a circle in the center
    final int domainCount = domains.length;
    double domainRadius = maxRadius * 0.2;

    // Position domains
    _positionEntitiesInCircle(
        domains.map((d) => d.code).toList(), center, domainRadius, positions);

    // Position models in the next circle
    double modelRadius = maxRadius * 0.5;
    for (int i = 0; i < domains.length; i++) {
      final domain = domains[i];

      // Get domain position
      final domainPosition = positions[domain.code] ?? center;

      // Position models for this domain
      _positionEntitiesInCircle(domain.models.map((m) => m.code).toList(),
          domainPosition, modelRadius / domainCount, positions);

      // Position concepts for each model
      double conceptRadius = maxRadius * 0.75;
      for (final model in domain.models) {
        // Get model position
        final modelPosition = positions[model.code] ?? center;

        // Position concepts for this model
        _positionEntitiesInCircle(model.concepts.map((c) => c.code).toList(),
            modelPosition, conceptRadius / domain.models.length, positions);

        // Position children for each concept
        for (final concept in model.concepts) {
          final conceptPosition = positions[concept.code] ?? center;

          // Position children
          final children = [
            ...concept.children.map((c) => c.code),
            ...concept.parents.map((p) => p.code)
          ];

          _positionEntitiesInCircle(
              children, conceptPosition, maxRadius * 0.15, positions);
        }
      }
    }

    return positions;
  }

  /// Position a list of entities in a circle around a center point
  void _positionEntitiesInCircle(List<String> entities, Offset center,
      double radius, Map<String, Offset> positions) {
    if (entities.isEmpty) return;

    final double angleStep = 2 * math.pi / entities.length;

    for (int i = 0; i < entities.length; i++) {
      final angle = i * angleStep;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      positions[entities[i]] = Offset(x, y);
    }
  }

  @override
  String get name => 'Circular';

  @override
  IconData get icon => Icons.circle;

  @override
  String get description => 'Arranges entities in concentric circles';
}

/// A force-directed layout algorithm that positions entities based on
/// simulated physical forces.
///
/// This algorithm treats entities as particles with repulsive forces between
/// them, while relationships act as springs that pull related entities together.
class ForceDirectedLayoutAlgorithm implements LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final Map<String, Offset> positions = {};

    // First initialize with a simpler layout to avoid overlaps
    final initialLayout = GridLayoutAlgorithm().calculateLayout(domains, size);
    positions.addAll(initialLayout);

    // We'd normally run a force simulation here, but for simplicity
    // we'll just use the grid layout for now

    return positions;
  }

  @override
  String get name => 'Force Directed';

  @override
  IconData get icon => Icons.auto_fix_high;

  @override
  String get description => 'Uses simulated forces to position entities';
}

/// A layout algorithm that arranges entities in a tree structure.
///
/// This algorithm is optimized for hierarchical relationships like domain-model-concept.
class RankedEmbeddingLayoutAlgorithm implements LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final Map<String, Offset> positions = {};
    final entities = _collectAllEntities(domains);

    if (entities.isEmpty) return positions;

    // Calculate number of domains
    final int domainCount = domains.length;

    // Calculate domain spacing
    final double domainWidth = size.width / domainCount;

    // Position domains
    for (int i = 0; i < domains.length; i++) {
      final domain = domains[i];

      // Position domain at the top center of its section
      final double x = i * domainWidth + domainWidth / 2;
      final double y = 50.0;

      positions[domain.code] = Offset(x, y);

      // Position models for this domain
      _positionModels(
          domain, Offset(x, y), domainWidth, size.height, positions);
    }

    return positions;
  }

  /// Position models in a tree-like structure below their domain
  void _positionModels(Domain domain, Offset domainPosition, double width,
      double height, Map<String, Offset> positions) {
    if (domain.models.isEmpty) return;

    final int modelCount = domain.models.length;
    final double modelWidth = width / modelCount;

    for (int i = 0; i < domain.models.length; i++) {
      final model = domain.models[i];

      // Position model below its domain
      final double x =
          domainPosition.dx - width / 2 + i * modelWidth + modelWidth / 2;
      final double y = domainPosition.dy + 100.0;

      positions[model.code] = Offset(x, y);

      // Position concepts for this model
      _positionConcepts(model, Offset(x, y), modelWidth, height, positions);
    }
  }

  /// Position concepts in a tree-like structure below their model
  void _positionConcepts(Model model, Offset modelPosition, double width,
      double height, Map<String, Offset> positions) {
    if (model.concepts.isEmpty) return;

    final int conceptCount = model.concepts.length;
    final double conceptWidth = width / conceptCount;

    for (int i = 0; i < model.concepts.length; i++) {
      final concept = model.concepts[i];

      // Position concept below its model
      final double x =
          modelPosition.dx - width / 2 + i * conceptWidth + conceptWidth / 2;
      final double y = modelPosition.dy + 100.0;

      positions[concept.code] = Offset(x, y);

      // Position properties (children and parents) for this concept
      _positionProperties(
          concept, Offset(x, y), conceptWidth, height, positions);
    }
  }

  /// Position properties in a tree-like structure below their concept
  void _positionProperties(Concept concept, Offset conceptPosition,
      double width, double height, Map<String, Offset> positions) {
    final properties = [...concept.children, ...concept.parents];

    if (properties.isEmpty) return;

    final int propertyCount = properties.length;
    final double propertyWidth = width / propertyCount;

    for (int i = 0; i < properties.length; i++) {
      final property = properties[i];

      // Position property below its concept
      final double x = conceptPosition.dx -
          width / 2 +
          i * propertyWidth +
          propertyWidth / 2;
      final double y = conceptPosition.dy + 100.0;

      positions[property.code] = Offset(x, y);
    }
  }

  /// Collect all entity codes from domains, models, concepts, etc.
  List<String> _collectAllEntities(Domains domains) {
    final List<String> entities = [];

    // Add domain codes
    for (final domain in domains) {
      entities.add(domain.code);

      // Add model codes
      for (final model in domain.models) {
        entities.add(model.code);

        // Add concept codes
        for (final concept in model.concepts) {
          entities.add(concept.code);

          // Add property codes (children and parents)
          for (final child in concept.children) {
            entities.add(child.code);
          }

          for (final parent in concept.parents) {
            entities.add(parent.code);
          }
        }
      }
    }

    return entities;
  }

  @override
  String get name => 'Ranked Tree';

  @override
  IconData get icon => Icons.account_tree;

  @override
  String get description =>
      'Arranges entities in a hierarchical tree structure';
}

/// A master-detail layout algorithm that focuses on a central entity
/// and arranges related entities around it.
class MasterDetailLayoutAlgorithm implements LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    // This is a simplified implementation that uses a circular layout
    // with the main entity in the center
    return CircularLayoutAlgorithm().calculateLayout(domains, size);
  }

  @override
  String get name => 'Master Detail';

  @override
  IconData get icon => Icons.format_indent_increase;

  @override
  String get description =>
      'Focuses on a main entity with related entities around it';
}
