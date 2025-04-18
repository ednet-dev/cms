import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:flutter/foundation.dart';

import 'model_selection_event.dart';
import 'model_selection_state.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member
/// Bloc for handling model selection actions and state
class ModelSelectionBloc
    extends Bloc<ModelSelectionEvent, ModelSelectionState> {
  final ednet.IOneApplication app;

  ModelSelectionBloc({required this.app})
    : super(ModelSelectionState.initial()) {
    on<InitializeModelSelectionEvent>(_onInitialize);
    on<UpdateModelsForDomainEvent>(_onUpdateModelsForDomain);
    on<SelectModelEvent>(_onSelectModel);
    on<ClearModelSelectionEvent>(_onClearModelSelection);
  }

  /// Handles the initialize event
  void _onInitialize(
    InitializeModelSelectionEvent event,
    Emitter<ModelSelectionState> emit,
  ) {
    // The model list will be populated when a domain is selected
    emit(state);
  }

  /// Handles updating the models list when a domain is selected
  void _onUpdateModelsForDomain(
    UpdateModelsForDomainEvent event,
    Emitter<ModelSelectionState> emit,
  ) {
    try {
      debugPrint('🔍 Updating models for domain: ${event.domain.code}');

      // First, clear the current state to prevent type mismatches
      emit(ModelSelectionState.initial());

      final domain = event.domain;
      final models = domain.models;

      debugPrint('🔍 Found ${models.length} models in domain ${domain.code}');

      emit(
        ModelSelectionState(
          selectedModel: null, // Don't auto-select model
          availableModels: models,
          domain: domain,
        ),
      );
    } catch (e, stack) {
      debugPrint('❌ Error in _onUpdateModelsForDomain: $e');
      debugPrint('❌ Stack trace: $stack');
      emit(ModelSelectionState.initial());
    }
  }

  /// Handles the select model event
  void _onSelectModel(
    SelectModelEvent event,
    Emitter<ModelSelectionState> emit,
  ) {
    try {
      debugPrint('🔍 Selecting model: ${event.model.code}');

      // First clear the current state to prevent type mismatches
      emit(state.copyWith(selectedModel: null));

      emit(
        state.copyWith(selectedModel: event.model, domain: event.model.domain),
      );
    } catch (e, stack) {
      debugPrint('❌ Error in _onSelectModel: $e');
      debugPrint('❌ Stack trace: $stack');
      emit(ModelSelectionState.initial());
    }
  }

  /// Handles the clear model selection event
  void _onClearModelSelection(
    ClearModelSelectionEvent event,
    Emitter<ModelSelectionState> emit,
  ) {
    emit(ModelSelectionState.initial());
  }

  /// A method to directly update models in the state
  /// This is a workaround for initialization issues
  void updateModelsDirectly(ednet.Models models) {
    if (models.isEmpty) return;

    emit(
      ModelSelectionState(
        availableModels: models,
        selectedModel: state.selectedModel,
      ),
    );
  }
}
