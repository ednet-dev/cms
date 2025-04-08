import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/domain/repositories/entity_repository.dart';
import 'entity_event.dart';
import 'entity_state.dart';

/// Bloc for managing entity operations
class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final EntityRepository _repository;

  /// Creates a new entity bloc
  EntityBloc({required EntityRepository repository})
    : _repository = repository,
      super(EntityState.initial()) {
    on<LoadEntitiesEvent>(_onLoadEntities);
    on<SelectEntityEvent>(_onSelectEntity);
    on<PrepareCreateEntityEvent>(_onPrepareCreateEntity);
    on<CreateEntityEvent>(_onCreateEntity);
    on<PrepareUpdateEntityEvent>(_onPrepareUpdateEntity);
    on<UpdateEntityEvent>(_onUpdateEntity);
    on<DeleteEntityEvent>(_onDeleteEntity);
    on<SetFormFieldValueEvent>(_onSetFormFieldValue);
    on<ClearSelectionEvent>(_onClearSelection);
  }

  Future<void> _onLoadEntities(
    LoadEntitiesEvent event,
    Emitter<EntityState> emit,
  ) async {
    emit(
      state.copyWith(
        status: EntityStatus.loading,
        clearError: true,
        clearSelectedEntity: true,
      ),
    );

    try {
      final entities = await _repository.getEntities(
        event.domain,
        event.model,
        event.concept,
      );

      emit(state.copyWith(status: EntityStatus.loaded, entities: entities));
    } catch (e) {
      emit(
        state.copyWith(
          status: EntityStatus.failure,
          errorMessage: 'Failed to load entities: $e',
        ),
      );
    }
  }

  void _onSelectEntity(SelectEntityEvent event, Emitter<EntityState> emit) {
    emit(state.copyWith(selectedEntity: event.entity, clearError: true));
  }

  void _onPrepareCreateEntity(
    PrepareCreateEntityEvent event,
    Emitter<EntityState> emit,
  ) {
    // Initialize form values with defaults based on the concept's attributes
    final formValues = <String, dynamic>{};

    for (final property in event.concept.attributes) {
      // Set default values based on attribute type
      final type = property.type?.toString().toLowerCase();
      if (type == 'string') {
        formValues[property.code] = '';
      } else if (type == 'int' || type == 'integer') {
        formValues[property.code] = 0;
      } else if (type == 'double' || type == 'float') {
        formValues[property.code] = 0.0;
      } else if (type == 'bool' || type == 'boolean') {
        formValues[property.code] = false;
      } else if (type == 'date' || type == 'datetime') {
        formValues[property.code] = DateTime.now();
      } else {
        formValues[property.code] = null;
      }
    }

    emit(
      state.copyWith(
        status: EntityStatus.creating,
        formValues: formValues,
        clearSelectedEntity: true,
        clearError: true,
      ),
    );
  }

  Future<void> _onCreateEntity(
    CreateEntityEvent event,
    Emitter<EntityState> emit,
  ) async {
    emit(state.copyWith(status: EntityStatus.creating, clearError: true));

    try {
      // Create the entity
      final entity = await _repository.createEntity(
        event.domain,
        event.model,
        event.concept,
        event.attributeValues,
      );

      // Add entity to the list
      final updatedEntities = List<Entity<dynamic>>.from(state.entities)
        ..add(entity);

      emit(
        state.copyWith(
          status: EntityStatus.success,
          entities: updatedEntities,
          selectedEntity: entity,
          formValues: const {}, // Clear form
        ),
      );

      // Reload entities to ensure latest data
      add(
        LoadEntitiesEvent(
          domain: event.domain,
          model: event.model,
          concept: event.concept,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EntityStatus.failure,
          errorMessage: 'Failed to create entity: $e',
        ),
      );
    }
  }

  void _onPrepareUpdateEntity(
    PrepareUpdateEntityEvent event,
    Emitter<EntityState> emit,
  ) {
    // Initialize form values from the entity's current values
    final formValues = <String, dynamic>{};

    for (final property in event.concept.attributes) {
      try {
        formValues[property.code] = event.entity.getAttribute(property.code);
      } catch (e) {
        // Set default value if attribute not found
        formValues[property.code] = null;
      }
    }

    emit(
      state.copyWith(
        status: EntityStatus.updating,
        selectedEntity: event.entity,
        formValues: formValues,
        clearError: true,
      ),
    );
  }

  Future<void> _onUpdateEntity(
    UpdateEntityEvent event,
    Emitter<EntityState> emit,
  ) async {
    emit(state.copyWith(status: EntityStatus.updating, clearError: true));

    try {
      // Update the entity
      final entity = await _repository.updateEntity(
        event.domain,
        event.model,
        event.concept,
        event.oid,
        event.attributeValues,
      );

      // Update entity in the list
      final updatedEntities =
          state.entities.map((e) {
            return e.oid == entity.oid ? entity : e;
          }).toList();

      emit(
        state.copyWith(
          status: EntityStatus.success,
          entities: updatedEntities,
          selectedEntity: entity,
          formValues: const {}, // Clear form
        ),
      );

      // Reload entities to ensure latest data
      add(
        LoadEntitiesEvent(
          domain: event.domain,
          model: event.model,
          concept: event.concept,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EntityStatus.failure,
          errorMessage: 'Failed to update entity: $e',
        ),
      );
    }
  }

  Future<void> _onDeleteEntity(
    DeleteEntityEvent event,
    Emitter<EntityState> emit,
  ) async {
    emit(state.copyWith(status: EntityStatus.deleting, clearError: true));

    try {
      // Delete the entity
      // Convert Oid to int using toString and int.parse if necessary
      final oidValue = int.parse(event.entity.oid.toString());

      final success = await _repository.deleteEntity(
        event.domain,
        event.model,
        event.concept,
        oidValue,
      );

      if (!success) {
        throw Exception('Failed to delete entity');
      }

      // Remove entity from the list
      final updatedEntities =
          state.entities.where((e) => e.oid != event.entity.oid).toList();

      emit(
        state.copyWith(
          status: EntityStatus.success,
          entities: updatedEntities,
          clearSelectedEntity: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EntityStatus.failure,
          errorMessage: 'Failed to delete entity: $e',
        ),
      );
    }
  }

  void _onSetFormFieldValue(
    SetFormFieldValueEvent event,
    Emitter<EntityState> emit,
  ) {
    // Update form values with the new field value
    final updatedFormValues = Map<String, dynamic>.from(state.formValues)
      ..[event.field] = event.value;

    emit(state.copyWith(formValues: updatedFormValues));
  }

  void _onClearSelection(ClearSelectionEvent event, Emitter<EntityState> emit) {
    emit(
      state.copyWith(
        clearSelectedEntity: true,
        clearError: true,
        formValues: const {}, // Clear form
      ),
    );
  }
}
