import 'dart:math';
import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/a_v_l_tree.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/layout_algorithm.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/meta_domain_canvas.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/tree_node.dart';

class ForceDirectedLayoutAlgorithm extends LayoutAlgorithm {
  final AVLTree avlTree = AVLTree();
  final Map<String, Offset> velocity = {};
  final double repulsionForce = 1000.0; // Adjusted repulsion force
  final double springForce = 0.1; // Spring force constant
  final int iterations = 1000; // Number of iterations for the algorithm
  final double damping =
      0.85; // Velocity damping factor to stabilize the layout

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final forces = <String, Offset>{};

    final random = Random();
    _initializePositions(domains, size, random);

    for (var i = 0; i < iterations; i++) {
      _applyForces(forces);
      _updatePositions(forces);
    }

    return _getPositions();
  }

  void _initializePositions(Domains domains, Size size, Random random) {
    for (var domain in domains) {
      avlTree.insertNode(
          domain.code,
          Offset(random.nextDouble() * size.width,
              random.nextDouble() * size.height));

      for (var model in domain.models) {
        avlTree.insertNode(
            model.code,
            Offset(random.nextDouble() * size.width,
                random.nextDouble() * size.height));

        for (var entity in model.concepts) {
          avlTree.insertNode(
              entity.code,
              Offset(random.nextDouble() * size.width,
                  random.nextDouble() * size.height));

          for (var child in entity.children) {
            avlTree.insertNode(
                child.code,
                Offset(random.nextDouble() * size.width,
                    random.nextDouble() * size.height));
          }
        }
      }
    }
  }

  void _applyForces(Map<String, Offset> forces) {
    final positions = _getPositions();

    for (var entry in positions.entries) {
      final position = entry.value;
      var force = Offset.zero;

      for (var otherEntry in positions.entries) {
        if (entry.key == otherEntry.key) continue;

        final direction = position - otherEntry.value;
        final distance = max(direction.distance, 0.1); // Avoid division by zero
        final repulsion =
            direction / distance * repulsionForce / (distance * distance);

        force += repulsion;
      }

      forces[entry.key] = force;
    }

    for (var domain in positions.keys) {
      for (var model in positions.keys) {
        if (domain == model) continue;
        final direction = positions[domain]! - positions[model]!;
        final distance = max(direction.distance, 1.0);
        final attraction =
            direction / distance * springForce * log(distance + 1);

        forces[domain] = forces[domain]! - attraction;
        forces[model] = forces[model]! + attraction;
      }
    }
  }

  void _updatePositions(Map<String, Offset> forces) {
    final positions = _getPositions();

    for (var entry in positions.entries) {
      final force = forces[entry.key]!;
      final velocity =
          (this.velocity[entry.key] ?? Offset.zero) + force * springForce;

      avlTree.insertNode(entry.key, entry.value + velocity);
      this.velocity[entry.key] = velocity * damping;
    }
  }

  Map<String, Offset> _getPositions() {
    final positions = <String, Offset>{};
    void traverse(TreeNode? node) {
      if (node == null) return;
      positions[node.key] = node.position;
      traverse(node.left);
      traverse(node.right);
    }

    traverse(avlTree.root);
    return positions;
  }
}
