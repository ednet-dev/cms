part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Service for managing UX Component Filters in the Shell Architecture
///
/// This service provides functionality for:
/// - Creating and managing filters
/// - Applying filters to UI components
/// - Saving and loading filter presets
/// - Integration with Message Filter pattern from EDNet Core
/// - Persistence using SharedPreferences
class FilterService extends ChangeNotifier {
  static const String _presetStorageKey = 'shell_filter_presets';
  static const String _activeFilterKey = 'shell_active_filter';

  /// UX channel for filter-related messages
  final UXChannel _filterChannel = UXChannel(
    'filter_channel',
    name: 'Filter Message Channel',
  );

  /// In-memory cache of filter presets
  List<FilterPreset> _presets = [];

  /// Currently active filter
  FilterGroup? _activeFilter;

  /// Flag indicating if presets have been loaded from storage
  bool _isLoaded = false;

  /// Static singleton instance
  static final FilterService _instance = FilterService._internal();

  /// Factory constructor that returns a singleton instance
  factory FilterService() {
    return _instance;
  }

  /// Private constructor for singleton pattern
  FilterService._internal() {
    _setupMessageHandlers();
  }

  /// Set up handlers for filter-related messages
  void _setupMessageHandlers() {
    _filterChannel.onUXMessageType('apply_filter', (message) async {
      final filterData = message.payload['filter'] as Map<String, dynamic>;
      final filterGroup = FilterGroup.fromJson(filterData);
      await applyFilter(filterGroup);
    });

    _filterChannel.onUXMessageType('clear_filter', (message) async {
      await clearFilter();
    });

    _filterChannel.onUXMessageType('save_preset', (message) async {
      final presetData = message.payload['preset'] as Map<String, dynamic>;
      final preset = FilterPreset.fromJson(presetData);
      await savePreset(preset);
    });

    _filterChannel.onUXMessageType('delete_preset', (message) async {
      final id = message.payload['id'] as String;
      await deletePreset(id);
    });
  }

  /// Get the filter UX channel
  UXChannel get filterChannel => _filterChannel;

  /// Get all filter presets
  Future<List<FilterPreset>> getPresets() async {
    if (!_isLoaded) {
      await _loadPresets();
    }
    return _presets;
  }

  /// Get the currently active filter
  Future<FilterGroup?> getActiveFilter() async {
    if (!_isLoaded) {
      await _loadPresets();
    }
    return _activeFilter;
  }

  /// Apply a filter
  Future<void> applyFilter(FilterGroup? filter) async {
    _activeFilter = filter;
    await _saveActiveFilter();
    notifyListeners();

    // Send message about the applied filter
    _sendFilterMessage('filter_applied', {
      'filter': filter?.toJson(),
    });
  }

  /// Clear the active filter
  Future<void> clearFilter() async {
    _activeFilter = null;
    await _saveActiveFilter();
    notifyListeners();

    // Send message about clearing the filter
    _sendFilterMessage('filter_cleared', {});
  }

  /// Save a filter preset
  Future<void> savePreset(FilterPreset preset) async {
    if (!_isLoaded) await _loadPresets();

    // Check if preset with same ID already exists
    final existingIndex = _presets.indexWhere((p) => p.id == preset.id);
    if (existingIndex != -1) {
      // Update existing preset
      _presets[existingIndex] = preset;
    } else {
      // Add new preset
      _presets.add(preset);
    }

    await _savePresets();

    // Send message about the saved preset
    _sendFilterMessage('preset_saved', {
      'preset': preset.toJson(),
    });
  }

  /// Delete a preset by ID
  Future<void> deletePreset(String presetId) async {
    if (!_isLoaded) await _loadPresets();

    final preset = _presets.firstWhere(
      (p) => p.id == presetId,
      orElse: () => throw Exception('Preset not found: $presetId'),
    );

    // Don't allow deleting system presets
    if (preset.isSystem) {
      throw Exception('Cannot delete system preset: ${preset.name}');
    }

    _presets.removeWhere((p) => p.id == presetId);
    await _savePresets();

    // Send message about the deleted preset
    _sendFilterMessage('preset_deleted', {
      'id': presetId,
    });
  }

  /// Get a filter preset by ID
  Future<FilterPreset?> getPresetById(String id) async {
    if (!_isLoaded) await _loadPresets();

    try {
      return _presets.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search presets using a text query
  Future<List<FilterPreset>> searchPresets(String searchTerm) async {
    if (searchTerm.isEmpty) return getPresets();

    final allPresets = await getPresets();
    final lowerSearch = searchTerm.toLowerCase();

    return allPresets.where((preset) {
      return preset.name.toLowerCase().contains(lowerSearch) ||
          (preset.description?.toLowerCase().contains(lowerSearch) ?? false);
    }).toList();
  }

  /// Create a filter from a Message Filter predicate
  Future<FilterGroup> createFilterFromPredicate(
    MessagePredicate predicate, {
    String? name,
    String? description,
  }) async {
    // This is a simplified implementation that would need to be extended
    // to properly convert complex predicates to filter criteria

    // Create a basic criterion that delegates to the predicate
    final criteria = FilterCriteria(
      field: 'payload',
      operator: FilterOperator.equals,
      valueType: FilterValueType.text,
      value: 'Custom predicate',
    );

    return FilterGroup(
      criteria: [criteria],
      logic: FilterGroupLogic.and,
      name: name,
      description: description,
    );
  }

  /// Create a Message Filter from a filter group
  Future<MessageFilter> createMessageFilter(
    FilterGroup filterGroup,
    UXChannel sourceChannel,
    UXChannel targetChannel, {
    required String name,
  }) async {
    // This would require adaptation between UXChannel and Channel from ednet_core
    // In a real implementation, we would need to create a channel adapter
    throw UnimplementedError(
        'Direct conversion between UXChannel and ednet_core Channel not implemented. '
        'Use FilterEntity methods instead for domain integration.');
  }

  /// Create an EDNet Core message filter
  Future<EDNetCoreMessageFilter?> createEntityFilter(
    FilterGroup filterGroup,
    UXChannel sourceChannel,
    UXChannel targetChannel, {
    required String name,
    required FilterEntity entity,
  }) async {
    // This would require adaptation between UXChannel and Channel from ednet_core
    // In a real implementation, we would need to create a channel adapter
    throw UnimplementedError(
        'Direct conversion between UXChannel and ednet_core Channel not implemented. '
        'Use FilterEntity methods instead for domain integration.');
  }

  /// Import filter presets from JSON
  Future<void> importPresets(String jsonData) async {
    try {
      final List<dynamic> presetList = json.decode(jsonData);
      final importedPresets = presetList
          .map((item) => FilterPreset.fromJson(item as Map<String, dynamic>))
          .toList();

      if (!_isLoaded) await _loadPresets();

      // Add imported presets
      for (final preset in importedPresets) {
        final existingIndex = _presets.indexWhere((p) => p.id == preset.id);
        if (existingIndex != -1) {
          _presets[existingIndex] = preset;
        } else {
          _presets.add(preset);
        }
      }

      await _savePresets();

      // Send message about importing presets
      _sendFilterMessage('presets_imported', {
        'count': importedPresets.length,
      });
    } catch (e) {
      debugPrint('Error importing filter presets: $e');
      rethrow;
    }
  }

  /// Export filter presets to JSON
  Future<String> exportPresets() async {
    if (!_isLoaded) await _loadPresets();

    final presetList = _presets.map((preset) => preset.toJson()).toList();
    return json.encode(presetList);
  }

  /// Load presets from SharedPreferences
  Future<void> _loadPresets() async {
    final prefs = await SharedPreferences.getInstance();

    // Load presets
    final presetStrings = prefs.getStringList(_presetStorageKey);
    if (presetStrings == null) {
      _presets = [];
    } else {
      _presets = presetStrings
          .map((presetJson) {
            try {
              final Map<String, dynamic> presetMap = json.decode(presetJson);
              return FilterPreset.fromJson(presetMap);
            } catch (e) {
              debugPrint('Error parsing filter preset: $e');
              return null;
            }
          })
          .where((preset) => preset != null)
          .cast<FilterPreset>()
          .toList();
    }

    // Load active filter
    final activeFilterJson = prefs.getString(_activeFilterKey);
    if (activeFilterJson != null) {
      try {
        final Map<String, dynamic> filterMap = json.decode(activeFilterJson);
        _activeFilter = FilterGroup.fromJson(filterMap);
      } catch (e) {
        debugPrint('Error parsing active filter: $e');
        _activeFilter = null;
      }
    }

    _isLoaded = true;
  }

  /// Save presets to SharedPreferences
  Future<void> _savePresets() async {
    final prefs = await SharedPreferences.getInstance();
    final presetStrings =
        _presets.map((preset) => json.encode(preset.toJson())).toList();

    await prefs.setStringList(_presetStorageKey, presetStrings);
    notifyListeners();
  }

  /// Save active filter to SharedPreferences
  Future<void> _saveActiveFilter() async {
    final prefs = await SharedPreferences.getInstance();
    if (_activeFilter == null) {
      await prefs.remove(_activeFilterKey);
    } else {
      await prefs.setString(
        _activeFilterKey,
        json.encode(_activeFilter!.toJson()),
      );
    }
  }

  /// Send a filter-related message on the UX channel
  void _sendFilterMessage(String type, Map<String, dynamic> payload) {
    _filterChannel.sendUXMessage(UXMessage.create(
      type: type,
      payload: {
        ...payload,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      source: 'filter_service',
    ));
  }
}
