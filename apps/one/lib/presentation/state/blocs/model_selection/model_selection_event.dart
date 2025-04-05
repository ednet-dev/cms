import 'package:ednet_core/ednet_core.dart';

/// Base class for all model selection events
abstract class ModelSelectionEvent {}

/// Event to initialize the model selection bloc
class InitializeModelSelectionEvent extends ModelSelectionEvent {}

/// Event to update models when domain changes
class UpdateModelsForDomainEvent extends ModelSelectionEvent {
  final Domain domain;

  UpdateModelsForDomainEvent(this.domain);
}

/// Event to select a specific model
class SelectModelEvent extends ModelSelectionEvent {
  final Model model;

  SelectModelEvent(this.model);
}
