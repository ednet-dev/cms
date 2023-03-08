// import 'package:ednet_core/ednet_core.dart';
//
// class DomainModelGraph extends Graph {
//   DomainModelGraph(this.domainModel, super.nodes, super.egdes) {
//     build();
//   }
//
//   final DomainModel domainModel;
//
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
