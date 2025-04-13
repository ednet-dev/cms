part of ednet_core_flutter;

/// Manages domain-related state and operations for the shell application
class ShellDomainManager extends ChangeNotifier {
  final List<Domain> _domains;
  Domain? _selectedDomain;
  Model? _selectedModel;
  Concept? _selectedConcept;
  Entity? _selectedEntity;
  bool _isTreeMode = true;

  // Domain change stream controller
  final _domainChangeController = StreamController<Domain>.broadcast();
  Stream<Domain> get onDomainChanged => _domainChangeController.stream;

  // Current domain index for multi-domain support
  int _currentDomainIndex = 0;

  ShellDomainManager(this._domains) {
    if (_domains.isEmpty) {
      throw ArgumentError('Domains list cannot be empty');
    }
    _currentDomainIndex = 0;
    if (_domains.isNotEmpty) {
      _selectedDomain = _domains.first;
    }
  }

  List<Domain> get domains => List.unmodifiable(_domains);
  Domain? get selectedDomain => _selectedDomain;
  Model? get selectedModel => _selectedModel;
  Concept? get selectedConcept => _selectedConcept;
  Entity? get selectedEntity => _selectedEntity;
  bool get isTreeMode => _isTreeMode;

  // For multi-domain shell support
  int get currentDomainIndex => _currentDomainIndex;
  Domain get currentDomain => _domains[_currentDomainIndex];

  void setTreeMode(bool isTree) {
    if (_isTreeMode != isTree) {
      _isTreeMode = isTree;
      notifyListeners();
    }
  }

  void selectDomain(Domain? domain) {
    if (_selectedDomain != domain) {
      _selectedDomain = domain;
      _selectedModel = null;
      _selectedConcept = null;
      _selectedEntity = null;

      if (domain != null) {
        _domainChangeController.add(domain);
      }

      notifyListeners();
    }
  }

  void selectModel(Model? model) {
    if (_selectedModel != model) {
      _selectedModel = model;
      _selectedConcept = null;
      _selectedEntity = null;
      notifyListeners();
    }
  }

  void selectConcept(Concept? concept) {
    if (_selectedConcept != concept) {
      _selectedConcept = concept;
      _selectedEntity = null;
      notifyListeners();
    }
  }

  void selectEntity(Entity? entity) {
    if (_selectedEntity != entity) {
      _selectedEntity = entity;
      notifyListeners();
    }
  }

  void selectArtifact(Object? artifact) {
    if (artifact == null) {
      _selectedDomain = null;
      _selectedModel = null;
      _selectedConcept = null;
      _selectedEntity = null;
      notifyListeners();
      return;
    }

    if (artifact is Domain) {
      selectDomain(artifact);
    } else if (artifact is Model) {
      selectModel(artifact);
    } else if (artifact is Concept) {
      selectConcept(artifact);
    } else if (artifact is Entity) {
      selectEntity(artifact);
    }
  }

  /// Switch to a domain by index
  void switchToDomain(int index) {
    if (index < 0 || index >= _domains.length) {
      throw ArgumentError('Domain index out of range: $index');
    }

    if (_currentDomainIndex != index) {
      _currentDomainIndex = index;
      _domainChangeController.add(currentDomain);
      notifyListeners();
    }
  }

  /// Switch to a domain by code
  void switchToDomainByCode(String code) {
    final index = _domains.indexWhere((d) => d.code == code);
    if (index == -1) {
      throw ArgumentError('Domain with code $code not found');
    }
    switchToDomain(index);
  }

  /// Get a domain by code
  Domain getDomain(String code) {
    final domain = _domains.firstWhere(
      (d) => d.code == code,
      orElse: () => throw ArgumentError('Domain with code $code not found'),
    );
    return domain;
  }

  // Domain change observer methods
  StreamSubscription<Domain> addDomainChangeObserver(
      void Function(Domain) observer) {
    return _domainChangeController.stream.listen(observer);
  }

  /// Returns the currently selected artifact based on the most specific selection
  Object? get selectedArtifact {
    if (_selectedEntity != null) return _selectedEntity;
    if (_selectedConcept != null) return _selectedConcept;
    if (_selectedModel != null) return _selectedModel;
    return _selectedDomain;
  }

  /// Validates that all domains are properly initialized
  bool validateDomains() {
    if (_domains.isEmpty) {
      print('Warning: No domains available in ShellDomainManager');
      return false;
    }

    for (final domain in _domains) {
      if (domain.models.isEmpty) {
        print('Warning: Domain ${domain.code} has no models');
        continue;
      }

      for (final model in domain.models) {
        if (model.concepts.isEmpty) {
          print(
              'Warning: Model ${model.code} in domain ${domain.code} has no concepts');
        }
      }
    }

    return true;
  }

  /// Checks if persistence is enabled for a domain
  bool isDomainPersistenceEnabled(Domain domain) {
    return domain.models.isNotEmpty;
  }

  /// Initializes persistence for all domains
  Future<void> initializePersistence() async {
    // This is a simplified version as the actual persistence implementation
    // would depend on the specific domain model capabilities
    for (final domain in _domains) {
      print('Initializing persistence for domain: ${domain.code}');
    }
  }

  /// Get domains that have model changes based on diff detection
  Future<List<Domain>> getDomainsWithChanges(ShellApp shellApp) async {
    final domainsWithChanges = <Domain>[];

    for (final domain in _domains) {
      final diff = shellApp.exportDomainModelDiff(domain.code);
      if (diff != '{}') {
        domainsWithChanges.add(domain);
      }
    }

    return domainsWithChanges;
  }

  /// Persist diffs for all domains that have changes
  Future<Map<String, bool>> persistAllDomainModelDiffs(
      ShellApp shellApp) async {
    final results = <String, bool>{};

    for (final domain in _domains) {
      final result = await shellApp.persistCurrentDomainModelDiff(domain.code);
      results[domain.code] = result;
    }

    return results;
  }

  /// Load and apply the latest persisted diffs for all domains
  Future<Map<String, bool>> loadAndApplyAllDomainModelDiffs(
      ShellApp shellApp) async {
    final results = <String, bool>{};

    for (final domain in _domains) {
      final result =
          await shellApp.loadAndApplyLatestDomainModelDiff(domain.code);
      results[domain.code] = result;
    }

    return results;
  }

  /// Reset all domains to their baseline state
  Future<void> resetAllDomainsToBaseline(ShellApp shellApp) async {
    for (final domain in _domains) {
      await shellApp.saveModelStateAsBaseline(domain.code);
    }
  }

  @override
  void dispose() {
    _domainChangeController.close();
    super.dispose();
  }
}
