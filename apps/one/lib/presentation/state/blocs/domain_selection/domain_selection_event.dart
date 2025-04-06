import 'package:ednet_core/ednet_core.dart' as ednet;

/// Base class for all domain selection events
abstract class DomainSelectionEvent {}

/// Event to initialize the domain selection bloc
class InitializeDomainSelectionEvent extends DomainSelectionEvent {}

/// Event to load domains from a repository
class LoadDomainsEvent extends DomainSelectionEvent {
  /// The domains to load
  final ednet.Domains domains;

  /// The domain to select initially (optional)
  final ednet.Domain? selectedDomain;

  /// Creates a load domains event
  LoadDomainsEvent({required this.domains, this.selectedDomain});
}

/// Event to select a specific domain
class SelectDomainEvent extends DomainSelectionEvent {
  final ednet.Domain domain;

  SelectDomainEvent(this.domain);
}
