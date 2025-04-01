part of eventstorming;

/// Implementation of a connection between EventStorming elements.
class ESConnectionImpl implements ESConnection {
  @override
  final ESElement source;
  
  @override
  final ESElement target;
  
  @override
  final ESConnectionType type;
  
  /// Label for the connection, if any.
  final String? label;
  
  /// Style for the connection line.
  final String? lineStyle;
  
  /// Creates a new connection between elements.
  ESConnectionImpl({
    required this.source,
    required this.target,
    required this.type,
    this.label,
    this.lineStyle,
  });
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'sourceId': source.id,
      'targetId': target.id,
      'type': type.toString().split('.').last,
      if (label != null) 'label': label,
      if (lineStyle != null) 'lineStyle': lineStyle,
    };
  }
  
  @override
  List<Object?> get props => [source.id, target.id, type];
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ESConnectionImpl &&
        other.source.id == source.id &&
        other.target.id == target.id &&
        other.type == type;
  }
  
  @override
  int get hashCode => Object.hash(source.id, target.id, type);
} 