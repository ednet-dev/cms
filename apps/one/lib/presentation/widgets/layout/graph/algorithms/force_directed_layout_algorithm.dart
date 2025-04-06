import 'dart:math';
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';
import 'quadtree.dart'; // Assuming you have implemented a Quadtree

class ForceDirectedLayoutAlgorithm extends LayoutAlgorithm {
  final Map<String, Offset> positions = {};
  final Map<String, Offset> velocity = {};
  final double repulsionForce = 1000.0; // Adjusted repulsion force
  final double springForce = 0.1; // Spring force constant
  final int iterations =
      500; // Reduced number of iterations for better performance
  final double damping =
      0.85; // Velocity damping factor to stabilize the layout

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final forces = <String, Offset>{};

    final random = Random();
    _initializePositions(domains, size, random);

    for (var i = 0; i < iterations; i++) {
      _applyForces(forces, size);
      _updatePositions(forces);
    }

    return positions;
  }

  void _initializePositions(Domains domains, Size size, Random random) {
    for (var domain in domains) {
      positions[domain.code] = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      for (var model in domain.models) {
        positions[model.code] = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );

        for (var entity in model.concepts) {
          positions[entity.code] = Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          );

          for (var child in entity.children) {
            positions[child.code] = Offset(
              random.nextDouble() * size.width,
              random.nextDouble() * size.height,
            );
          }
        }
      }
    }
  }

  void _applyForces(Map<String, Offset> forces, Size size) {
    final quadTree = Quadtree(
      bounds: Rect.fromLTWH(0, 0, size.width, size.height),
    );

    // Insert positions into the quadtree
    positions.forEach((key, position) {
      quadTree.insert(key, position);
    });

    forces.clear();

    positions.forEach((key, position) {
      var force = Offset.zero;

      // Apply repulsive forces using the quadtree
      quadTree.query(position, (otherKey, otherPosition) {
        if (key == otherKey) return;

        final direction = position - otherPosition;
        final distance = max(direction.distance, 0.1); // Avoid division by zero
        final repulsion =
            direction / distance * repulsionForce / (distance * distance);

        force += repulsion;
      });

      forces[key] = force;
    });

    // Apply attractive forces
    for (var domain in positions.keys) {
      for (var model in positions.keys) {
        if (domain == model) continue;
        final direction = positions[domain]! - positions[model]!;
        final distance = max(direction.distance, 1.0);
        final attraction =
            direction / distance * springForce * log(distance + 1);

        forces[domain] = (forces[domain] ?? Offset.zero) - attraction;
        forces[model] = (forces[model] ?? Offset.zero) + attraction;
      }
    }
  }

  void _updatePositions(Map<String, Offset> forces) {
    positions.forEach((key, position) {
      final force = forces[key] ?? Offset.zero;
      final velocity =
          (this.velocity[key] ?? Offset.zero) + force * springForce;

      positions[key] = position + velocity;
      this.velocity[key] = velocity * damping;
    });
  }
}
