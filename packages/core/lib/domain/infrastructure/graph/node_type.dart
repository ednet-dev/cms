part of ednet_core;
/// Defines the types of nodes that can exist in a domain model graph.
///
/// This class represents different categories of nodes in the graph:
/// - [Event]: Represents domain events that have occurred
/// - [Command]: Represents actions that can be taken on the domain
/// - [AggregateRoot]: Represents aggregate root entities
/// - [Role]: Represents roles or responsibilities in the domain
///
/// This is particularly useful for:
/// - Categorizing nodes in the domain model
/// - Visualizing different types of domain concepts
/// - Organizing the graph structure
///
/// Example usage:
/// ```dart
/// final node = Node(
///   id: 'order-1',
///   type: NodeType.AggregateRoot,
///   position: Offset(100, 100),
///   size: 40.0,
///   paint: Paint()..color = Colors.blue,
/// );
/// ```
class NodeType {
  /// Creates a new node type with the given name.
  /// 
  /// Parameters:
  /// - [name]: The name of the node type
  const NodeType._(this.name);

  /// The name of this node type.
  final String name;

  /// Represents a domain event node.
  static const NodeType Event = NodeType._('Event');

  /// Represents a command node.
  static const NodeType Command = NodeType._('Command');

  /// Represents an aggregate root node.
  static const NodeType AggregateRoot = NodeType._('AggregateRoot');

  /// Represents a role node.
  static const NodeType Role = NodeType._('Role');
// add other node types here
}
