import 'package:ednet_core/ednet_core.dart';

abstract class DomainEvent {}

class InitializeDomainEvent extends DomainEvent {}

class SelectDomainEvent extends DomainEvent {
  final Domain domain;
  SelectDomainEvent(this.domain);
}

class SelectModelEvent extends DomainEvent {
  final Model model;
  SelectModelEvent(this.model);
}

class SelectConceptEvent extends DomainEvent {
  final Concept concept;
  SelectConceptEvent(this.concept);
}

class ExportDSLEvent extends DomainEvent {}

class GenerateCodeEvent extends DomainEvent {}