// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

part of ednet_flow;








class StormingSession {
  /// The unique identifier for this session.
  final String id;

  /// The name of this session (e.g., "Customer Ordering Domain Exploration").
  final String name;

  /// A more detailed description of this session.
  final String description;

  /// When this session was created.
  final DateTime createdAt;

  /// When this session was last updated.
  final DateTime lastUpdatedAt;

  /// Who created this session.
  final String createdBy;

  /// The current status of the session (e.g., "active", "completed").
  final String status;

  /// The event storming board associated with this session.
  final EventStormingBoard board;

  /// The participants in this session.
  final Map<String, StormingParticipant> participants;

  /// Any additional metadata for this session.
  final Map<String, dynamic> metadata;

  /// Creates a new event storming session.
  StormingSession({
    required this.id,
    required this.name,
    this.description = '',
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.createdBy,
    this.status = 'active',
    required this.board,
    this.participants = const {},
    this.metadata = const {},
  });

  /// Creates a session from a map representation.
  factory StormingSession.fromJson(Map<String, dynamic> json) {
    return StormingSession(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
      createdBy: json['createdBy'] as String,
      status: json['status'] as String? ?? 'active',
      board: EventStormingBoard.fromJson(json['board'] as Map<String, dynamic>),
      participants:
          (json['participants'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
              k,
              StormingParticipant.fromJson(v as Map<String, dynamic>),
            ),
          ) ??
          {},
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts this session to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'createdBy': createdBy,
      'status': status,
      'board': board.toJson(),
      'participants': participants.map((k, v) => MapEntry(k, v.toJson())),
      'metadata': metadata,
    };
  }

  /// Creates a copy of this session with the given fields replaced with new values.
  StormingSession copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    String? createdBy,
    String? status,
    EventStormingBoard? board,
    Map<String, StormingParticipant>? participants,
    Map<String, dynamic>? metadata,
  }) {
    return StormingSession(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      board: board ?? this.board,
      participants: participants ?? this.participants,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Updates the board of this session.
  StormingSession updateBoard(EventStormingBoard board) {
    return copyWith(board: board, lastUpdatedAt: DateTime.now());
  }

  /// Adds a participant to this session.
  StormingSession addParticipant(StormingParticipant participant) {
    return copyWith(
      participants: {...participants, participant.id: participant},
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Removes a participant from this session.
  StormingSession removeParticipant(String participantId) {
    final newParticipants = Map<String, StormingParticipant>.from(participants);
    newParticipants.remove(participantId);
    return copyWith(
      participants: newParticipants,
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Updates a participant in this session.
  StormingSession updateParticipant(StormingParticipant participant) {
    return copyWith(
      participants: {...participants, participant.id: participant},
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Updates the status of this session.
  StormingSession updateStatus(String status) {
    return copyWith(status: status, lastUpdatedAt: DateTime.now());
  }

  /// Creates a new session with a pre-initialized board.
  ///
  /// This factory method provides a convenient way to create a new session
  /// with a pre-initialized board, ready for event storming.
  factory StormingSession.create({
    required String id,
    required String name,
    String description = '',
    required String createdBy,
    required String boardId,
    required String boardName,
    String boardDescription = '',
  }) {
    final now = DateTime.now();
    final board = EventStormingBoard(
      id: boardId,
      name: boardName,
      description: boardDescription,
      createdAt: now,
      createdBy: createdBy,
    );

    return StormingSession(
      id: id,
      name: name,
      description: description,
      createdAt: now,
      lastUpdatedAt: now,
      createdBy: createdBy,
      board: board,
    );
  }
}
