import 'package:ednet_core/ednet_core.dart' as ednet;

/// Base class for all concept selection events
abstract class ConceptSelectionEvent {}

/// Event to initialize the concept selection bloc
class InitializeConceptSelectionEvent extends ConceptSelectionEvent {}

/// Event to update concepts when model changes
class UpdateConceptsForModelEvent extends ConceptSelectionEvent {
  final ednet.Model model;
  final dynamic domainModelGraph;

  UpdateConceptsForModelEvent(this.model, {this.domainModelGraph});
}

/// Event to select a specific concept
class SelectConceptEvent extends ConceptSelectionEvent {
  final ednet.Concept concept;

  SelectConceptEvent(this.concept);
}

/// Event to export a DSL from the current concept/model
class ExportDSLEvent extends ConceptSelectionEvent {}

/// Event to trigger code generation
class GenerateCodeEvent extends ConceptSelectionEvent {}

/// Event to refresh a specific concept and reload its entities
class RefreshConceptEvent extends ConceptSelectionEvent {
  final ednet.Concept concept;

  RefreshConceptEvent(this.concept);
}
