import 'dart:math' as math;
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';
import 'enhanced_quadtree.dart';

/// An optimized force-directed layout algorithm for visualizing large domain models.
///
/// This implementation uses the Barnes-Hut approximation algorithm to optimize
/// force calculations for large graphs, significantly improving performance.
class OptimizedForceDirectedLayout extends LayoutAlgorithm {
  /// Map of entity codes to positions
  final Map<String, Offset> positions = {};

  /// Map of entity codes to velocities
  final Map<String, Offset> velocities = {};

  /// Barnes-Hut theta parameter (0.0-1.0) - controls accuracy vs. speed tradeoff
  /// Lower values are more accurate but slower, higher values are faster but less accurate
  final double theta;

  /// Repulsion force constant
  final double repulsionForce;

  /// Spring force constant for connected entities
  final double springForce;

  /// Spring length (ideal distance between connected entities)
  final double springLength;

  /// Maximum iterations for layout calculation
  final int maxIterations;

  /// Velocity damping factor (0.0-1.0) to stabilize the layout
  final double damping;

  /// Cooling factor for adaptive time step
  final double coolingFactor;

  /// Random number generator for initial positions
  final math.Random random;

  /// Cache of quadtree to avoid recreating it for each iteration
  EnhancedQuadtree<String>? _quadtree;

  /// Whether to cache positions between calculations
  final bool cachePositions;

  /// Store of entity metadata for size calculations and rendering
  final Map<String, EntityMetadata> entityMetadata = {};

  /// Creates a new optimized force-directed layout algorithm.
  OptimizedForceDirectedLayout({
    this.theta = 0.8,
    this.repulsionForce = 1000.0,
    this.springForce = 0.1,
    this.springLength = 100.0,
    this.maxIterations = 300,
    this.damping = 0.9,
    this.coolingFactor = 0.95,
    this.cachePositions = true,
    math.Random? random,
  }) : random = random ?? math.Random();

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    // If caching is enabled and we have positions, don't recalculate from scratch
    if (!cachePositions || positions.isEmpty) {
      _initializePositions(domains, size);
    }

    // Create a map to store calculated forces for each entity
    final forces = <String, Offset>{};

    // Adaptive temperature for simulated annealing
    double temperature = 1.0;
    double timeStep = 1.0;

    // Store entity relationships for force calculations
    final relationships = _extractRelationships(domains);

    // Calculate entity metadata (size, depth, etc.)
    _calculateEntityMetadata(domains);

    // Run the force-directed algorithm for a fixed number of iterations
    for (var i = 0; i < maxIterations; i++) {
      timeStep *= coolingFactor;

      // Calculate forces using Barnes-Hut optimization
      _calculateForcesBarnesHut(forces, size, relationships);

      // Update positions based on calculated forces
      _updatePositions(forces, timeStep, temperature);

      // Reduce temperature over time to settle the layout
      temperature *= coolingFactor;

      // Check for convergence (if all entities have very small velocities)
      if (_isConverged(0.1)) {
        break;
      }
    }

    // Ensure all entities are within the visible area
    _centerAndScaleLayout(size);

    return positions;
  }

  /// Initializes random positions for all entities in the domain model.
  void _initializePositions(Domains domains, Size size) {
    positions.clear();
    velocities.clear();

    // Define padding from the edges
    final padding = math.min(size.width, size.height) * 0.1;
    final availableWidth = size.width - padding * 2;
    final availableHeight = size.height - padding * 2;

    for (var domain in domains) {
      _initializePosition(
        domain.code,
        padding,
        availableWidth,
        availableHeight,
      );

      for (var model in domain.models) {
        _initializePosition(
          model.code,
          padding,
          availableWidth,
          availableHeight,
        );

        for (var concept in model.concepts) {
          _initializePosition(
            concept.code,
            padding,
            availableWidth,
            availableHeight,
          );

          for (var child in concept.children) {
            _initializePosition(
              child.code,
              padding,
              availableWidth,
              availableHeight,
            );
          }

          for (var parent in concept.parents) {
            _initializePosition(
              parent.code,
              padding,
              availableWidth,
              availableHeight,
            );
          }
        }
      }
    }
  }

  /// Initializes a position for a single entity with given constraints.
  void _initializePosition(
    String code,
    double padding,
    double width,
    double height,
  ) {
    // Skip if already positioned
    if (positions.containsKey(code)) {
      return;
    }

    // Create a random position within the available space
    positions[code] = Offset(
      padding + random.nextDouble() * width,
      padding + random.nextDouble() * height,
    );

    // Initialize velocity to zero
    velocities[code] = Offset.zero;
  }

  /// Extracts relationship data from the domain model for force calculations.
  List<Relationship> _extractRelationships(Domains domains) {
    final relationships = <Relationship>[];

    for (var domain in domains) {
      for (var model in domain.models) {
        // Domain-Model relationship
        relationships.add(
          Relationship(
            source: domain.code,
            target: model.code,
            strength: 1.0,
            type: RelationshipType.domainToModel,
          ),
        );

        for (var concept in model.concepts) {
          // Model-Concept relationship
          relationships.add(
            Relationship(
              source: model.code,
              target: concept.code,
              strength: 1.0,
              type: RelationshipType.modelToConcept,
            ),
          );

          // Process concept children
          for (var child in concept.children) {
            relationships.add(
              Relationship(
                source: concept.code,
                target: child.code,
                strength: 1.5,
                type: RelationshipType.conceptToChild,
              ),
            );
          }

          // Process concept parents
          for (var parent in concept.parents) {
            relationships.add(
              Relationship(
                source: concept.code,
                target: parent.code,
                strength: 1.0,
                type: RelationshipType.conceptToParent,
              ),
            );
          }
        }
      }
    }

    return relationships;
  }

  /// Calculates forces using Barnes-Hut optimization algorithm.
  void _calculateForcesBarnesHut(
    Map<String, Offset> forces,
    Size size,
    List<Relationship> relationships,
  ) {
    forces.clear();

    // Initialize forces to zero for all entities
    for (var key in positions.keys) {
      forces[key] = Offset.zero;
    }

    // Build quadtree for Barnes-Hut optimization
    _buildQuadtree(size);

    // Calculate repulsive forces using Barnes-Hut approximation
    _calculateRepulsiveForces(forces);

    // Calculate attractive forces for connected entities
    _calculateAttractiveForces(forces, relationships);
  }

  /// Builds a quadtree containing all entity positions.
  void _buildQuadtree(Size size) {
    // Create a new quadtree or clear the existing one
    if (_quadtree == null) {
      _quadtree = EnhancedQuadtree<String>(
        bounds: Rect.fromLTWH(0, 0, size.width, size.height),
        capacity: 4,
      );
    } else {
      _quadtree!.clear();
    }

    // Insert all entities into the quadtree
    positions.forEach((key, position) {
      _quadtree!.insert(key, position);
    });
  }

  /// Calculates repulsive forces between entities using Barnes-Hut approximation.
  void _calculateRepulsiveForces(Map<String, Offset> forces) {
    // Process repulsive forces for each entity
    for (var key in positions.keys) {
      final position = positions[key]!;
      var force = Offset.zero;

      // Query points in range for optimization
      final nearbyPoints = <QuadPoint<String>>[];
      _quadtree!.queryRange(position, 500, nearbyPoints);

      // Apply repulsive forces from nearby entities
      for (var point in nearbyPoints) {
        if (key == point.data) continue;

        final otherPosition = point.position;
        final direction = position - otherPosition;
        final distance = math.max(
          direction.distance,
          0.1,
        ); // Avoid division by zero

        // Scale force by entity importance (larger/more central entities have more repulsion)
        final metadata = entityMetadata[key];
        final otherMetadata = entityMetadata[point.data];
        final scaleFactor =
            ((metadata?.importance ?? 1.0) +
                (otherMetadata?.importance ?? 1.0)) /
            2.0;

        // Calculate repulsion force using inverse square law
        final repulsion =
            direction /
            distance *
            repulsionForce *
            scaleFactor /
            (distance * distance);
        force += repulsion;
      }

      forces[key] = (forces[key] ?? Offset.zero) + force;
    }
  }

  /// Calculates attractive forces between connected entities.
  void _calculateAttractiveForces(
    Map<String, Offset> forces,
    List<Relationship> relationships,
  ) {
    for (var relationship in relationships) {
      final sourcePos = positions[relationship.source];
      final targetPos = positions[relationship.target];

      // Skip if either entity doesn't have a position
      if (sourcePos == null || targetPos == null) {
        continue;
      }

      final direction = sourcePos - targetPos;
      final distance = math.max(direction.distance, 0.1);

      // Calculate spring force based on Hooke's law with logarithmic scaling
      final displacement = distance - (springLength * relationship.strength);
      final displacementAbs =
          displacement >= 0 ? displacement : -displacement; // abs value
      final magnitude =
          springForce *
          math.log(displacementAbs + 1) *
          (displacement > 0 ? 1 : -1);
      final attraction = direction / distance * magnitude;

      // Apply attraction force with strength factor
      forces[relationship.source] =
          (forces[relationship.source] ?? Offset.zero) -
          attraction * relationship.strength;
      forces[relationship.target] =
          (forces[relationship.target] ?? Offset.zero) +
          attraction * relationship.strength;
    }
  }

  /// Updates entity positions based on calculated forces.
  void _updatePositions(
    Map<String, Offset> forces,
    double timeStep,
    double temperature,
  ) {
    for (var key in positions.keys) {
      final position = positions[key]!;
      final force = forces[key] ?? Offset.zero;

      // Update velocity using force and apply damping
      velocities[key] = (velocities[key] ?? Offset.zero) + force * timeStep;
      velocities[key] = velocities[key]! * damping;

      // Limit maximum velocity with temperature (simulated annealing)
      final velocity = velocities[key]!;
      final speedLimit = 50.0 * temperature;
      if (velocity.distance > speedLimit) {
        velocities[key] = velocity * (speedLimit / velocity.distance);
      }

      // Update position
      positions[key] = position + velocities[key]!;
    }
  }

  /// Centers and scales the layout to fit within the visible area.
  void _centerAndScaleLayout(Size size) {
    if (positions.isEmpty) return;

    // Find current bounds of the layout
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var position in positions.values) {
      minX = math.min(minX, position.dx);
      minY = math.min(minY, position.dy);
      maxX = math.max(maxX, position.dx);
      maxY = math.max(maxY, position.dy);
    }

    // Calculate center points
    final layoutWidth = maxX - minX;
    final layoutHeight = maxY - minY;
    final layoutCenterX = minX + layoutWidth / 2;
    final layoutCenterY = minY + layoutHeight / 2;
    final targetCenterX = size.width / 2;
    final targetCenterY = size.height / 2;

    // Calculate scaling if needed
    final padding = math.min(size.width, size.height) * 0.1;
    final targetWidth = size.width - padding * 2;
    final targetHeight = size.height - padding * 2;
    final scaleX = layoutWidth > 0 ? targetWidth / layoutWidth : 1.0;
    final scaleY = layoutHeight > 0 ? targetHeight / layoutHeight : 1.0;
    final scale = math.min(scaleX, scaleY);

    // Apply centering and scaling transforms to all positions
    for (var key in positions.keys) {
      final position = positions[key]!;
      final centered = Offset(
        (position.dx - layoutCenterX) * scale + targetCenterX,
        (position.dy - layoutCenterY) * scale + targetCenterY,
      );
      positions[key] = centered;
    }
  }

  /// Checks if the layout has converged (all entities have very small velocities).
  bool _isConverged(double threshold) {
    for (var velocity in velocities.values) {
      if (velocity.distance > threshold) {
        return false;
      }
    }
    return true;
  }

  /// Calculates metadata for entities to influence the layout.
  void _calculateEntityMetadata(Domains domains) {
    entityMetadata.clear();

    // First pass - collect basic data
    for (var domain in domains) {
      // Domain level
      entityMetadata[domain.code] = EntityMetadata(
        level: 0,
        size: 150.0,
        importance: 3.0,
      );

      for (var model in domain.models) {
        // Model level
        entityMetadata[model.code] = EntityMetadata(
          level: 1,
          size: 120.0,
          importance: 2.0,
        );

        for (var concept in model.concepts) {
          // Concept level
          entityMetadata[concept.code] = EntityMetadata(
            level: 2,
            size: 100.0,
            importance: 1.5,
          );

          // Child level
          for (var child in concept.children) {
            entityMetadata[child.code] = EntityMetadata(
              level: 3,
              size: 80.0,
              importance: 1.0,
            );
          }

          // Parent level
          for (var parent in concept.parents) {
            entityMetadata[parent.code] = EntityMetadata(
              level: 3,
              size: 80.0,
              importance: 1.0,
            );
          }
        }
      }
    }
  }
}

/// Represents a relationship between two entities in the domain model.
class Relationship {
  final String source;
  final String target;
  final double strength;
  final RelationshipType type;

  Relationship({
    required this.source,
    required this.target,
    this.strength = 1.0,
    required this.type,
  });
}

/// Types of relationships in the domain model.
enum RelationshipType {
  domainToModel,
  modelToConcept,
  conceptToChild,
  conceptToParent,
}

/// Metadata for an entity to influence layout calculations.
class EntityMetadata {
  final int level;
  final double size;
  final double importance;

  EntityMetadata({
    required this.level,
    required this.size,
    required this.importance,
  });
}
