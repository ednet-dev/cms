part of ednet_core_flutter;

/// Service for managing pinned artifacts in the UI
///
/// This service allows components to be "pinned" to persist their visibility
/// regardless of screen size or disclosure level settings.
///
/// Part of the EDNet Shell Architecture's layout system.
class SemanticPinningService {
  /// Repository for pinned artifacts
  final Map<String, Set<String>> _pinnedArtifacts = {};

  /// Flag indicating if the service has been initialized
  bool _initialized = false;

  /// SharedPreferences instance for persistence
  SharedPreferences? _prefs;

  /// Storage key for pinned artifacts
  static const String _storageKey = 'semantic_pinned_artifacts';

  /// Initialize the service and load any previously pinned artifacts
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _loadPinnedArtifacts();
      _initialized = true;
    } catch (e) {
      // Handle initialization error
      _initialized = false;
    }
  }

  /// Load previously pinned artifacts from storage
  void _loadPinnedArtifacts() {
    if (_prefs == null) return;

    final storedData = _prefs!.getString(_storageKey);
    if (storedData == null || storedData.isEmpty) return;

    try {
      final Map<String, dynamic> data = jsonDecode(storedData);

      data.forEach((modelCode, artifacts) {
        if (artifacts is List) {
          _pinnedArtifacts[modelCode] =
              Set<String>.from(artifacts.cast<String>());
        }
      });
    } catch (e) {
      // Handle JSON parsing error
    }
  }

  /// Save the current set of pinned artifacts to storage
  Future<void> _savePinnedArtifacts() async {
    if (_prefs == null) return;

    final dataToStore = <String, List<String>>{};

    _pinnedArtifacts.forEach((modelCode, artifacts) {
      dataToStore[modelCode] = artifacts.toList();
    });

    final jsonData = jsonEncode(dataToStore);
    await _prefs!.setString(_storageKey, jsonData);
  }

  /// Check if a specific artifact is pinned
  bool isPinned(String modelCode, String artifactId) {
    if (!_initialized || !_pinnedArtifacts.containsKey(modelCode)) {
      return false;
    }

    return _pinnedArtifacts[modelCode]!.contains(artifactId);
  }

  /// Pin an artifact to make it persistently visible
  Future<void> pinArtifact(String modelCode, String artifactId) async {
    if (!_initialized) await initialize();

    // Initialize the set for this model if it doesn't exist
    _pinnedArtifacts.putIfAbsent(modelCode, () => <String>{});

    // Add the artifact ID to the set
    _pinnedArtifacts[modelCode]!.add(artifactId);

    // Save the updated state
    await _savePinnedArtifacts();
  }

  /// Unpin an artifact to make it follow normal visibility rules
  Future<void> unpinArtifact(String modelCode, String artifactId) async {
    if (!_initialized) await initialize();

    if (_pinnedArtifacts.containsKey(modelCode)) {
      _pinnedArtifacts[modelCode]!.remove(artifactId);

      // Remove the model entry if it has no more pinned artifacts
      if (_pinnedArtifacts[modelCode]!.isEmpty) {
        _pinnedArtifacts.remove(modelCode);
      }

      // Save the updated state
      await _savePinnedArtifacts();
    }
  }

  /// Get all pinned artifacts for a model
  Set<String> getPinnedArtifacts(String modelCode) {
    if (!_initialized || !_pinnedArtifacts.containsKey(modelCode)) {
      return <String>{};
    }

    return Set<String>.from(_pinnedArtifacts[modelCode]!);
  }

  /// Clear all pinned artifacts
  Future<void> clearAllPins() async {
    if (!_initialized) await initialize();

    _pinnedArtifacts.clear();
    await _savePinnedArtifacts();
  }

  /// Clear pins for a specific model
  Future<void> clearModelPins(String modelCode) async {
    if (!_initialized) await initialize();

    _pinnedArtifacts.remove(modelCode);
    await _savePinnedArtifacts();
  }
}
