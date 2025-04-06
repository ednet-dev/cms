import 'package:ednet_core/ednet_core.dart' as ednet;

abstract class DomainEvent {}

class InitializeDomainEvent extends DomainEvent {}

class SelectDomainEvent extends DomainEvent {
  final ednet.Domain domain;
  SelectDomainEvent(this.domain);
}

class SelectModelEvent extends DomainEvent {
  final ednet.Model model;
  SelectModelEvent(this.model);
}

class SelectConceptEvent extends DomainEvent {
  final ednet.Concept concept;
  SelectConceptEvent(this.concept);
}

class ExportDSLEvent extends DomainEvent {}

class GenerateCodeEvent extends DomainEvent {}
