part of ednet_core_flutter;

/// Extends ShellApp to support multiple domains
extension ShellAppDomainExtension on ShellApp {
  /// Initializes the shell with multiple domains
  void initializeWithDomains(List<Domain> domains,
      {int initialDomainIndex = 0}) {
    if (_domainManager == null) {
      // Create a domain manager with the provided domains
      _domainManager = ShellDomainManager(domains);

      // Set initial domain index
      if (initialDomainIndex >= 0 && initialDomainIndex < domains.length) {
        (_domainManager as ShellDomainManager)
            .switchToDomain(initialDomainIndex);
      }
    }
  }

  /// Access to the domain manager
  ShellDomainManager? get domainManager => _domainManager;

  /// Switch to a different domain by index
  void switchToDomain(int domainIndex) {
    domainManager?.switchToDomain(domainIndex);
    notifyListeners(); // Notify listeners of the change
  }

  /// Switch to a different domain by code
  void switchToDomainByCode(String domainCode) {
    domainManager?.switchToDomainByCode(domainCode);
    notifyListeners(); // Notify listeners of the change
  }

  /// Get all available domains
  List<Domain>? get availableDomains => domainManager?.domains;

  /// Get the currently selected domain index
  int get currentDomainIndex => domainManager?.currentDomainIndex ?? 0;

  /// Check if this ShellApp manages multiple domains
  bool get isMultiDomain =>
      domainManager != null && domainManager!.domains.length > 1;
}
