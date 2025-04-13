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

  /// Export domain model diff for a specific domain by index
  String exportDomainModelDiffByIndex(int domainIndex) {
    if (domainIndex < 0 ||
        domainManager == null ||
        domainIndex >= domainManager!.domains.length) {
      return '{}';
    }

    final domain = domainManager!.domains[domainIndex];
    return exportDomainModelDiff(domain.code);
  }

  /// Import domain model diff for a specific domain by index
  Future<bool> importDomainModelDiffByIndex(
      int domainIndex, String jsonDiff) async {
    if (domainIndex < 0 ||
        domainManager == null ||
        domainIndex >= domainManager!.domains.length) {
      return false;
    }

    final domain = domainManager!.domains[domainIndex];
    return await importDomainModelDiff(domain.code, jsonDiff);
  }

  /// Export diffs for all domains as a single consolidated JSON
  String exportAllDomainModelDiffs() {
    if (domainManager == null) {
      return '{}';
    }

    final Map<String, dynamic> allDiffs = {};
    for (final domain in domainManager!.domains) {
      final diff = exportDomainModelDiff(domain.code);
      if (diff != '{}') {
        allDiffs[domain.code] = jsonDecode(diff);
      }
    }

    return jsonEncode(allDiffs);
  }

  /// Import diffs for multiple domains from a consolidated JSON
  Future<bool> importAllDomainModelDiffs(String jsonAllDiffs) async {
    try {
      final Map<String, dynamic> allDiffs = jsonDecode(jsonAllDiffs);
      var success = false;

      for (final domainEntry in allDiffs.entries) {
        final domainCode = domainEntry.key;
        final domainDiff = jsonEncode(domainEntry.value);
        final result = await importDomainModelDiff(domainCode, domainDiff);
        success = success || result;
      }

      return success;
    } catch (e) {
      debugPrint('Error importing all domain diffs: $e');
      return false;
    }
  }
}
