// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

part of ednet_flow;







class StormingParticipant {
  /// The unique identifier for this participant.
  final String id;

  /// The name of the participant.
  final String name;

  /// The email of the participant.
  final String email;

  /// The role of the participant (e.g., "Domain Expert", "Developer").
  final String role;

  /// The color associated with this participant for identifying contributions.
  final String color;

  /// When this participant joined the session.
  final DateTime joinedAt;

  /// Whether this participant is currently active in the session.
  final bool isActive;

  /// Creates a new participant.
  StormingParticipant({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.color,
    required this.joinedAt,
    this.isActive = true,
  });

  /// Creates a participant from a map representation.
  factory StormingParticipant.fromJson(Map<String, dynamic> json) {
    return StormingParticipant(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      color: json['color'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Converts this participant to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'color': color,
      'joinedAt': joinedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Creates a copy of this participant with the given fields replaced with new values.
  StormingParticipant copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? color,
    DateTime? joinedAt,
    bool? isActive,
  }) {
    return StormingParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      color: color ?? this.color,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Sets the active state of this participant.
  StormingParticipant setActive(bool active) {
    return copyWith(
      isActive: active,
    );
  }
} 