import 'package:ednet_core/ednet_core.dart';

/// Base class for all domain selection events
abstract class DomainSelectionEvent {}

/// Event to initialize the domain selection bloc
class InitializeDomainSelectionEvent extends DomainSelectionEvent {}

/// Event to select a specific domain
class SelectDomainEvent extends DomainSelectionEvent {
  final Domain domain;

  SelectDomainEvent(this.domain);
}
