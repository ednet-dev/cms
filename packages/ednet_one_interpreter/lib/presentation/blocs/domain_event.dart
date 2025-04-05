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

class GenerateCodeEvent extends DomainBlocEvent {}
