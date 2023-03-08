class NodeType {
  const NodeType._(this.name);

  final String name;

  static const NodeType Event = NodeType._('Event');
  static const NodeType Command = NodeType._('Command');
  static const NodeType AggregateRoot = NodeType._('AggregateRoot');
  static const NodeType Role = NodeType._('Role');
// add other node types here
}
