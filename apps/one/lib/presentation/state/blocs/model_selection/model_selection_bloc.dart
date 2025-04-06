import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart';

import 'model_selection_event.dart';
import 'model_selection_state.dart';

/// Bloc for handling model selection actions and state
class ModelSelectionBloc
    extends Bloc<ModelSelectionEvent, ModelSelectionState> {
  final IOneApplication app;

  ModelSelectionBloc({required this.app})
    : super(ModelSelectionState.initial()) {
    on<InitializeModelSelectionEvent>(_onInitialize);
    on<UpdateModelsForDomainEvent>(_onUpdateModelsForDomain);
    on<SelectModelEvent>(_onSelectModel);
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
    Domain domain = event.domain;
    Model? selectedModel;

    if (domain.models.isNotEmpty) {
      selectedModel = domain.models.first;
    }

    emit(
      state.copyWith(
        selectedModel: selectedModel,
        availableModels: domain.models,
        domain: domain,
      ),
    );
  }

  /// Handles the select model event
  void _onSelectModel(
    SelectModelEvent event,
    Emitter<ModelSelectionState> emit,
  ) {
    emit(state.copyWith(selectedModel: event.model));
  }

  /// A method to directly update models in the state
  /// This is a workaround for initialization issues
  void updateModelsDirectly(Models models) {
    if (models.isEmpty) return;

    emit(
      ModelSelectionState(
        availableModels: models,
        selectedModel: state.selectedModel,
      ),
    );
  }
}
