// import 'domain_model_graph.dart';
//
// class GraphVisualizationWidget extends StatelessWidget {
//   final DomainModelGraph graph;
//   final double iconPadding = 10; // distance between icon and node center
//   final double iconSize = 24; // size of the icon
//   final Alignment iconAlignment =
//       Alignment.centerLeft; // icon position relative to node center
//
//   GraphVisualizationWidget({@required this.graph});
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _GraphVisualizationPainter(
//         graph: graph,
//         iconPadding: iconPadding,
//         iconSize: iconSize,
//         iconAlignment: iconAlignment,
//       ),
//     );
//   }
// }
//
// class _GraphVisualizationPainter extends CustomPainter {
//   final DomainModelGraph graph;
//   final double iconPadding;
//   final double iconSize;
//   final Alignment iconAlignment;
//
//   _GraphVisualizationPainter({
//     @required this.graph,
//     @required this.iconPadding,
//     @required this.iconSize,
//     @required this.iconAlignment,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var node in graph.nodes) {
//       final icon = _getNodeIcon(node.type);
//       final iconPosition = _calculateIconPosition(
//           node.position, iconAlignment, iconPadding, iconSize);
//       canvas.drawCircle(node.position, node.size, node.paint);
//       canvas.drawIcon(icon, iconPosition, iconPaint);
//     }
//   }
//
//   IconData _getNodeIcon(NodeType type) {
//     switch (type) {
//       case NodeType.Event:
//         return Icons.event;
//       case NodeType.Command:
//         return Icons.send;
//       case NodeType.AggregateRoot:
//         return Icons.dashboard;
//       case NodeType.Role:
//         return Icons.person;
//       // add other node types here
//     }
//     return null;
//   }
//
//   Offset _calculateIconPosition(
//       Offset nodePosition, Alignment alignment, double padding, double size) {
//     final x = nodePosition.dx + alignment.x * (padding + size / 2);
//     final y = nodePosition.dy + alignment.y * (padding + size / 2);
//     return Offset(x, y);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
