import 'package:ednet_core/ednet_core.dart';

abstract class DomainBlocEvent {}

class InitializeDomainEvent extends DomainBlocEvent {}

class SelectDomainEvent extends DomainBlocEvent {
  final Domain domain;
  SelectDomainEvent(this.domain);
}

class SelectModelEvent extends DomainBlocEvent {
  final Model model;
  SelectModelEvent(this.model);
}

class SelectConceptEvent extends DomainBlocEvent {
  final Concept concept;
  SelectConceptEvent(this.concept);
}

class ExportDSLEvent extends DomainBlocEvent {}

class GenerateCodeEvent extends DomainBlocEvent {
  final Domain? domain;
  final Model? model;

  GenerateCodeEvent({this.domain, this.model});
}

/// Event triggered when a domain model needs to be updated.
class UpdateDomainModelEvent extends DomainBlocEvent {
  final Domain domain;
  final Model model;
  final Map<String, dynamic> updates;

  UpdateDomainModelEvent({
    required this.domain,
    required this.model,
    required this.updates,
  });
}

/// Event triggered when domain model changes need to be saved.
class SaveDomainModelChangesEvent extends DomainBlocEvent {
  final Domain domain;
  final Model model;

  SaveDomainModelChangesEvent({required this.domain, required this.model});
}

/// Event triggered to switch between staging and production environments.
class SwitchEnvironmentEvent extends DomainBlocEvent {
  final bool useStaging;

  SwitchEnvironmentEvent({required this.useStaging});
}

/// Event triggered to list available specifications in the requirements folder.
class ListSpecificationsEvent extends DomainBlocEvent {}

/// Event triggered to load a domain model from a specification.
class LoadFromSpecificationEvent extends DomainBlocEvent {
  final String domainCode;
  final String modelCode;

  LoadFromSpecificationEvent({
    required this.domainCode,
    required this.modelCode,
  });
}

/// Event triggered to create a new concept in the current model.
class CreateConceptEvent extends DomainBlocEvent {
  final String code;
  final String description;
  final Map<String, dynamic> attributes;

  CreateConceptEvent({
    required this.code,
    required this.description,
    this.attributes = const {},
  });
}

/// Event triggered to update an existing concept.
class UpdateConceptEvent extends DomainBlocEvent {
  final Concept concept;
  final Map<String, dynamic> updates;

  UpdateConceptEvent({required this.concept, required this.updates});
}

/// Event triggered to delete a concept from the model.
class DeleteConceptEvent extends DomainBlocEvent {
  final Concept concept;

  DeleteConceptEvent({required this.concept});
}

/// Event triggered to save the current session state.
class SaveSessionEvent extends DomainBlocEvent {}

/// Event triggered to restore a previously saved session.
class RestoreSessionEvent extends DomainBlocEvent {}

/// Event triggered to save navigation state.
class SaveNavigationStateEvent extends DomainBlocEvent {
  final List<String> path;
  final String layoutType;

  SaveNavigationStateEvent({required this.path, required this.layoutType});
}

/// Event triggered to restore navigation state.
class RestoreNavigationStateEvent extends DomainBlocEvent {}

/// Event triggered to save a draft of the current domain model.
class SaveDraftEvent extends DomainBlocEvent {
  final Domain domain;
  final Model model;

  SaveDraftEvent({required this.domain, required this.model});
}

/// Event triggered to load a draft of a domain model.
class LoadDraftEvent extends DomainBlocEvent {
  final String domainCode;
  final String modelCode;

  LoadDraftEvent({required this.domainCode, required this.modelCode});
}

/// Event triggered to list all available drafts.
class ListDraftsEvent extends DomainBlocEvent {}

/// Event triggered to commit a draft to the main specification.
class CommitDraftEvent extends DomainBlocEvent {
  final String domainCode;
  final String modelCode;

  CommitDraftEvent({required this.domainCode, required this.modelCode});
}

/// Event triggered to discard a draft.
class DiscardDraftEvent extends DomainBlocEvent {
  final String domainCode;
  final String modelCode;

  DiscardDraftEvent({required this.domainCode, required this.modelCode});
}

/// Event triggered to list version history for a domain model.
class ListVersionsEvent extends DomainBlocEvent {
  final String domainCode;
  final String modelCode;

  ListVersionsEvent({required this.domainCode, required this.modelCode});
}

/// Event triggered to load a specific version of a domain model.
class LoadVersionEvent extends DomainBlocEvent {
  final String domainCode;
  final String modelCode;
  final String versionTimestamp;

  LoadVersionEvent({
    required this.domainCode,
    required this.modelCode,
    required this.versionTimestamp,
  });
}
