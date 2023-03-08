// import 'package:ednet_core/ednet_core.dart';
// import 'package:flutter/material.dart';
//
// extension NodeTypeExtension on NodeType {
//   Color get color {
//     switch (this) {
//       case NodeType.Event:
//         return Colors.blue;
//       case NodeType.Command:
//         return Colors.green;
//       case NodeType.AggregateRoot:
//         return Colors.red;
//       case NodeType.Role:
//         return Colors.orange;
//       default:
//         return Colors.black;
//     }
//   }
// }
//
// extension EdgeTypeExtension on EdgeType {
//   Color get color {
//     switch (this) {
//       case EdgeType.Directed:
//         return Colors.black;
//       case EdgeType.Undirected:
//         return Colors.black;
//       default:
//         return Colors.black;
//     }
//   }
// }
//
// extension EdgeDirectionExtension on EdgeDirection {
//   double get angle {
//     switch (this) {
//       case EdgeDirection.LeftToRight:
//         return 0;
//       case EdgeDirection.RightToLeft:
//         return 180;
//       default:
//         return 0;
//     }
//   }
// }
//
// //
// // Path: lib/src/utilities/dsl/visualization/graph_visualitazion_widget.dart
// // Compare this snippet from test/ednet_semantics_test.dart:
// // import 'package:flutter_test/flutter_test.dart';
// //
// // import 'package:ednet_semantics/ednet_semantics.dart';
// //
// // void main() {
// //   test('adds one to input values', () {
// //     final calculator = Calculator();
// //
// //     expect(calculator.addOne(2), 3);
// //     expect(calculator.addOne(-7), -6);
// //     expect(calculator.addOne(0), 1);
// //   });
// // }
// //
// // import 'package:flutter/material.dart';
// //
// // class GraphVisualizationWidget extends StatefulWidget {
// //   GraphVisualizationWidget(this.graph, {Key key}) : super(key: key);
// //
// //   final Graph graph;
// //
// //   @override
// //   _GraphVisualizationWidgetState createState() =>
// //       _GraphVisualizationWidgetState();
// // }
// //
// // class _GraphVisualizationWidgetState extends State<GraphVisualizationWidget> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return CustomPaint(
// //       painter: GraphPainter(widget.graph),
// //     );
// //   }
// // }
// //
