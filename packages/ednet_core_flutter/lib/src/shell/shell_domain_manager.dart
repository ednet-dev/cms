part of ednet_core_flutter;

/// Manages domain-related state and operations for the shell application
class ShellDomainManager extends ChangeNotifier {
  final List<Domain> _domains;
  Domain? _selectedDomain;
  Model? _selectedModel;
  Concept? _selectedConcept;
  Entity? _selectedEntity;
  bool _isTreeMode = false;

  // Domain change streams
  final _domainChangeController = StreamController<Domain>.broadcast();

  // Current domain index for multi-domain support
  int _currentDomainIndex = 0;

  ShellDomainManager(this._domains) {
    if (_domains.isNotEmpty) {
      _selectedDomain = _domains.first;
      _currentDomainIndex = 0;
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

  // Multi-domain support methods
  void switchToDomain(int domainIndex) {
    if (domainIndex < 0 || domainIndex >= _domains.length) {
      throw ArgumentError(
          'Domain index $domainIndex out of range (0-${_domains.length - 1})');
    }

    if (domainIndex != _currentDomainIndex) {
      _currentDomainIndex = domainIndex;

      // Notify domain change observers
      _domainChangeController.add(currentDomain);
      notifyListeners();
    }
  }

  void switchToDomainByCode(String domainCode) {
    final index = _domains.indexWhere((domain) => domain.code == domainCode);

    if (index >= 0) {
      switchToDomain(index);
    } else {
      throw ArgumentError('Domain with code $domainCode not found');
    }
  }

  Domain? getDomain(String code) {
    return _domains.firstWhere((domain) => domain.code == code,
        orElse: () => throw ArgumentError('Domain with code $code not found'));
  }

  // Domain change observer methods
  void addDomainChangeObserver(void Function(Domain) observer) {
    _domainChangeController.stream.listen(observer);
  }

  void removeDomainChangeObserver(void Function(Domain) observer) {
    // This is a stub implementation as StreamController doesn't directly support
    // removing specific listeners. In a full implementation, you would need to
    // maintain a list of subscriptions.
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

    for (var domain in _domains) {
      if (domain.models.isEmpty) {
        print('Warning: Domain ${domain.code} has no models');
        continue;
      }

      for (var model in domain.models) {
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
    for (var domain in _domains) {
      print('Initializing persistence for domain: ${domain.code}');
    }
  }

  @override
  void dispose() {
    _domainChangeController.close();
    super.dispose();
  }
}
