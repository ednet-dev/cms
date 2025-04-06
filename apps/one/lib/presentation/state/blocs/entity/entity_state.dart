import 'package:equatable/equatable.dart';
import 'package:ednet_core/ednet_core.dart';

/// Status of entity operations
enum EntityStatus {
  /// Initial state
  initial,

  /// Loading data
  loading,

  /// Data loaded successfully
  loaded,

  /// Creating a new entity
  creating,

  /// Updating an entity
  updating,

  /// Deleting an entity
  deleting,

  /// Operation completed successfully
  success,

  /// Operation failed
  failure,
}

/// State for entity operations
class EntityState extends Equatable {
  /// Current status of entity operations
  final EntityStatus status;

  /// List of entities for the concept
  final List<Entity<dynamic>> entities;

  /// Currently selected entity
  final Entity<dynamic>? selectedEntity;

  /// Maps attribute codes to values for entity form
  final Map<String, dynamic> formValues;

  /// Error message if any
  final String? errorMessage;

  /// Creates a new entity state
  const EntityState({
    this.status = EntityStatus.initial,
    this.entities = const [],
    this.selectedEntity,
    this.formValues = const {},
    this.errorMessage,
  });

  /// Creates a copy of this state with the given fields replaced
  EntityState copyWith({
    EntityStatus? status,
    List<Entity<dynamic>>? entities,
    Entity<dynamic>? selectedEntity,
    Map<String, dynamic>? formValues,
    String? errorMessage,
    bool clearError = false,
    bool clearSelectedEntity = false,
  }) {
    return EntityState(
      status: status ?? this.status,
      entities: entities ?? this.entities,
      selectedEntity:
          clearSelectedEntity ? null : (selectedEntity ?? this.selectedEntity),
      formValues: formValues ?? this.formValues,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// Initial state factory
  factory EntityState.initial() => const EntityState();

  @override
  List<Object?> get props => [
    status,
    entities,
    selectedEntity,
    formValues,
    errorMessage,
  ];
}
