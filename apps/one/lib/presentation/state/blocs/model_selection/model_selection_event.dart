import 'package:ednet_core/ednet_core.dart' as ednet;

/// Base class for all model selection events
abstract class ModelSelectionEvent {}

/// Event to initialize the model selection bloc
class InitializeModelSelectionEvent extends ModelSelectionEvent {}

/// Event to update models when domain changes
class UpdateModelsForDomainEvent extends ModelSelectionEvent {
  final ednet.Domain domain;

  UpdateModelsForDomainEvent(this.domain);
}

/// Event to select a specific model
class SelectModelEvent extends ModelSelectionEvent {
  final ednet.Model model;

  SelectModelEvent(this.model);
}
