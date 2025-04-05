// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;

/// A layout algorithm that arranges nodes in a circle.
///
/// This algorithm positions nodes evenly around the circumference of a circle.
/// It's simple but effective for smaller graphs where the relationships
/// between nodes are of equal importance.
class CircularLayoutAlgorithm implements LayoutAlgorithm {
  /// Creates a new circular layout algorithm.
  CircularLayoutAlgorithm();

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        min(size.width, size.height) * 0.4; // Use 40% of the available space

    // Count all nodes to determine spacing
    int totalNodes = 0;
    for (var domain in domains) {
      totalNodes++; // Count domain
      for (var model in domain.models) {
        totalNodes++; // Count model
        totalNodes += model.concepts.length; // Count concepts
      }
    }

    // Position nodes in a circle
    int nodeIndex = 0;

    // First position domains
    for (var domain in domains) {
      final angle = 2 * pi * nodeIndex / totalNodes;
      positions[domain.code] = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      nodeIndex++;

      // Create a smaller concentric circle for each domain's models
      final modelRadius = radius * 0.7;
      final modelsInDomain = domain.models.length;

      for (int modelIndex = 0; modelIndex < modelsInDomain; modelIndex++) {
        final model = domain.models[modelIndex];
        final modelAngle = 2 * pi * (nodeIndex + modelIndex) / totalNodes;

        positions[model.code] = Offset(
          center.dx + modelRadius * cos(modelAngle),
          center.dy + modelRadius * sin(modelAngle),
        );
        nodeIndex++;

        // Create an even smaller circle for concepts
        final conceptRadius = radius * 0.4;
        final conceptsInModel = model.concepts.length;

        for (
          int conceptIndex = 0;
          conceptIndex < conceptsInModel;
          conceptIndex++
        ) {
          final concept = model.concepts[conceptIndex];
          final conceptAngle = 2 * pi * (nodeIndex + conceptIndex) / totalNodes;

          positions[concept.code] = Offset(
            center.dx + conceptRadius * cos(conceptAngle),
            center.dy + conceptRadius * sin(conceptAngle),
          );

          // Also position any attribute nodes
          for (var attribute in concept.attributes) {
            final attributeId = '${concept.code}_${attribute.code}';
            // Position attributes slightly offset from their concept
            positions[attributeId] = Offset(
              positions[concept.code]!.dx + 20, // Small x offset
              positions[concept.code]!.dy + 20, // Small y offset
            );
          }
        }
        nodeIndex += conceptsInModel;
      }
    }

    return positions;
  }

  @override
  Map<String, Offset> calculateModelLayout(DomainModel model, Size size) {
    final positions = <String, Offset>{};
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.4;

    // Count total entities to calculate angles
    final entities = model.entities;
    final totalEntities = entities.length;

    // Position entities in a circle
    for (int i = 0; i < totalEntities; i++) {
      final entity = entities[i];
      final angle = 2 * pi * i / totalEntities;

      positions[entity.name] = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      // Position entity attributes in a smaller circle around the entity
      final attributeRadius = radius * 0.2;
      final attributes = entity.attributes;

      for (int j = 0; j < attributes.length; j++) {
        final attribute = attributes[j];
        final attributeAngle = 2 * pi * j / attributes.length;

        final attributeId = '${entity.name}_${attribute.name}';
        positions[attributeId] = Offset(
          positions[entity.name]!.dx + attributeRadius * cos(attributeAngle),
          positions[entity.name]!.dy + attributeRadius * sin(attributeAngle),
        );
      }
    }

    return positions;
  }
}
