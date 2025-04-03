// part of ednet_core;
//
// /// A specialized graph representation of a domain model.
// ///
// /// This class extends [Graph] to create a visual representation of a domain model
// /// where:
// /// - Nodes represent entities and their fields
// /// - Edges represent relationships between entities and their fields
// /// - The graph structure reflects the domain model's hierarchy
// ///
// /// The graph is automatically built from the domain model's entities and their
// /// relationships during construction.
// ///
// /// Example usage:
// /// ```dart
// /// final domainModel = DomainModel(...);
// /// final graph = DomainModelGraph(
// ///   domainModel: domainModel,
// ///   nodes: <Node>[],
// ///   edges: <Edge>[],
// /// );
// /// ```
// class DomainModelGraph extends Graph {
//   /// Creates a new domain model graph.
//   ///
//   /// Parameters:
//   /// - [domainModel]: The domain model to represent
//   /// - [nodes]: Initial list of nodes in the graph
//   /// - [edges]: Initial list of edges in the graph
//   DomainModelGraph(this.domainModel, super.nodes, super.egdes) {
//     build();
//   }
//
//   /// The domain model represented by this graph.
//   final DomainModel domainModel;
//
//   /// Builds the graph structure from the domain model.
//   ///
//   /// This method:
//   /// 1. Adds nodes for each entity in the domain model
//   /// 2. Adds nodes for each field of each entity
//   /// 3. Creates edges connecting entities to their fields
//   @override
//   void build() {
//     for (final entity in domainModel.entities) {
//       addNode(entity as Node);
//       for (final field in entity.children) {
//         addNode(field as Node);
//         addEdge(entity, field);
//       }
//     }
//   }
// }
