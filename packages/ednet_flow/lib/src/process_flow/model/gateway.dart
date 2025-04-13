// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;





enum GatewayType {
  /// Exclusive gateway (XOR) - only one outgoing path will be taken
  exclusive,

  /// Inclusive gateway (OR) - one or more outgoing paths may be taken
  inclusive,

  /// Parallel gateway (AND) - all outgoing paths will be taken
  parallel,

  /// Event-based gateway - path is chosen based on occurring event
  eventBased,

  /// Complex gateway - complex condition determines which paths are taken
  complex,
}

class Gateway {
  /// The unique identifier for this gateway.
  final String id;

  /// The name of this gateway.
  final String name;

  /// A more detailed description of this gateway.
  final String description;

  /// The type of this gateway.
  final GatewayType type;

  /// The condition expression for this gateway (applicable for exclusive and inclusive).
  final String? condition;

  /// Properties associated with this gateway.
  final Map<String, dynamic> properties;

  /// The position of this gateway in the visual representation.
  final GatewayPosition position;

  /// Creates a new gateway.
  const Gateway({
    required this.id,
    required this.name,
    this.description = '',
    required this.type,
    this.condition,
    this.properties = const {},
    this.position = const GatewayPosition(0, 0),
  });

  /// Converts this gateway to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'condition': condition,
      'properties': properties,
      'position': position.toJson(),
    };
  }

  /// Creates a Gateway from a JSON map.
  factory Gateway.fromJson(Map<String, dynamic> json) {
    return Gateway(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: _parseGatewayType(json['type'] as String? ?? 'exclusive'),
      condition: json['condition'] as String?,
      properties: (json['properties'] as Map<String, dynamic>?) ?? {},
      position: GatewayPosition.fromJson(
        (json['position'] as Map<String, dynamic>?) ?? {'x': 0, 'y': 0},
      ),
    );
  }

  /// Parses a gateway type string to a GatewayType enum.
  static GatewayType _parseGatewayType(String type) {
    switch (type.toLowerCase()) {
      case 'inclusive':
        return GatewayType.inclusive;
      case 'parallel':
        return GatewayType.parallel;
      case 'eventbased':
      case 'event-based':
        return GatewayType.eventBased;
      case 'complex':
        return GatewayType.complex;
      case 'exclusive':
      default:
        return GatewayType.exclusive;
    }
  }
}

class GatewayPosition {
  /// The x-coordinate.
  final double x;

  /// The y-coordinate.
  final double y;

  /// Creates a new gateway position.
  const GatewayPosition(this.x, this.y);

  /// Converts this position to a JSON map.
  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }

  /// Creates a GatewayPosition from a JSON map.
  factory GatewayPosition.fromJson(Map<String, dynamic> json) {
    return GatewayPosition(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }
}
