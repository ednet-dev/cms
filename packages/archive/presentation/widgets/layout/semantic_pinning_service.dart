import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for pinning semantic content in the UI
/// Allows developers to override the normal responsive behavior
class SemanticPinningService extends ChangeNotifier {
  /// Singleton instance
  static final SemanticPinningService _instance =
      SemanticPinningService._internal();

  /// Factory constructor to return the singleton instance
  factory SemanticPinningService() => _instance;

  /// Private constructor for singleton pattern
  SemanticPinningService._internal();

  /// Map of model codes to sets of pinned artifact IDs
  Map<String, Set<String>> _pinnedArtifacts = {};

  /// Flag to track if the service has been initialized
  bool _initialized = false;

  /// Initialize the service by loading pinned artifacts from persistent storage
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? pinnedJson = prefs.getString('pinned_artifacts');

      if (pinnedJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(pinnedJson);

        // Convert the JSON structure back to Map<String, Set<String>>
        _pinnedArtifacts = decoded.map((key, value) {
          return MapEntry(
            key,
            (value as List<dynamic>).map((e) => e.toString()).toSet(),
          );
        });
      }

      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing SemanticPinningService: $e');
      // Initialize with empty data in case of error
      _pinnedArtifacts = {};
      _initialized = true;
    }
  }

  /// Check if an artifact is pinned for a specific model
  bool isPinned(String modelCode, String artifactId) {
    if (!_initialized) {
      debugPrint(
        'Warning: SemanticPinningService not initialized when checking pin status',
      );
      return false;
    }

    final pinnedSet = _pinnedArtifacts[modelCode];
    return pinnedSet != null && pinnedSet.contains(artifactId);
  }

  /// Pin an artifact for a specific model
  Future<void> pinArtifact(String modelCode, String artifactId) async {
    if (!_initialized) await initialize();

    // Get or create the set for this model
    final pinnedSet = _pinnedArtifacts[modelCode] ?? {};
    pinnedSet.add(artifactId);
    _pinnedArtifacts[modelCode] = pinnedSet;

    await _saveToPersistentStorage();
    notifyListeners();
  }

  /// Unpin an artifact for a specific model
  Future<void> unpinArtifact(String modelCode, String artifactId) async {
    if (!_initialized) await initialize();

    final pinnedSet = _pinnedArtifacts[modelCode];
    if (pinnedSet != null) {
      pinnedSet.remove(artifactId);
      // Remove the model entry if no pins remain
      if (pinnedSet.isEmpty) {
        _pinnedArtifacts.remove(modelCode);
      } else {
        _pinnedArtifacts[modelCode] = pinnedSet;
      }

      await _saveToPersistentStorage();
      notifyListeners();
    }
  }

  /// Get all pinned artifacts for a specific model
  Set<String> getPinnedArtifactsForModel(String modelCode) {
    if (!_initialized) {
      debugPrint(
        'Warning: SemanticPinningService not initialized when getting pins',
      );
      return {};
    }

    return _pinnedArtifacts[modelCode] ?? {};
  }

  /// Clear all pins for a specific model
  Future<void> clearModelPins(String modelCode) async {
    if (!_initialized) await initialize();

    if (_pinnedArtifacts.containsKey(modelCode)) {
      _pinnedArtifacts.remove(modelCode);
      await _saveToPersistentStorage();
      notifyListeners();
    }
  }

  /// Save the current state to persistent storage
  Future<void> _saveToPersistentStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert the Map<String, Set<String>> to a JSON-serializable structure
      final Map<String, List<String>> serializable = _pinnedArtifacts.map(
        (key, value) => MapEntry(key, value.toList()),
      );

      await prefs.setString('pinned_artifacts', jsonEncode(serializable));
    } catch (e) {
      debugPrint('Error saving pinned artifacts: $e');
    }
  }
}
