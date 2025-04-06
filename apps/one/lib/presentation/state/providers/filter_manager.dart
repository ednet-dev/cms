import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/filters/filter_criteria.dart';
import '../../widgets/filters/filter_preset.dart';

/// A service class that manages filter state and persistence
class FilterManager extends ChangeNotifier {
  /// Current active filter
  FilterGroup? _activeFilter;

  /// All saved filter presets
  List<FilterPreset> _presets = [];

  /// Flag to indicate loading state
  bool _isLoading = false;

  /// SharedPreferences key for presets
  static const String _presetsKey = 'filter_presets';

  /// Constructor - loads presets immediately
  FilterManager() {
    _loadPresets();
  }

  /// Get the current active filter
  FilterGroup? get activeFilter => _activeFilter;

  /// Get all presets
  List<FilterPreset> get presets => _presets;

  /// Check if currently loading
  bool get isLoading => _isLoading;

  /// Set the current active filter
  void setActiveFilter(FilterGroup filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  /// Clear the active filter
  void clearActiveFilter() {
    _activeFilter = null;
    notifyListeners();
  }

  /// Add a new preset
  Future<void> addPreset(FilterPreset preset) async {
    _presets.add(preset);
    await _savePresets();
    notifyListeners();
  }

  /// Update an existing preset
  Future<void> updatePreset(FilterPreset preset) async {
    final index = _presets.indexWhere((p) => p.id == preset.id);
    if (index >= 0) {
      _presets[index] = preset;
      await _savePresets();
      notifyListeners();
    }
  }

  /// Delete a preset by ID
  Future<void> deletePreset(String id) async {
    _presets.removeWhere((preset) => preset.id == id);
    await _savePresets();
    notifyListeners();
  }

  /// Apply a preset as the active filter
  void applyPreset(FilterPreset preset) {
    if (preset.filterGroups.isNotEmpty) {
      _activeFilter = preset.filterGroups.first;
      notifyListeners();
    }
  }

  /// Load presets from SharedPreferences
  Future<void> _loadPresets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = prefs.getStringList(_presetsKey) ?? [];

      _presets = presetsJson.map((json) => _presetFromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading filter presets: $e');
      _presets = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Save presets to SharedPreferences
  Future<void> _savePresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson =
          _presets.map((preset) => _presetToJson(preset)).toList();

      await prefs.setStringList(_presetsKey, presetsJson);
    } catch (e) {
      debugPrint('Error saving filter presets: $e');
    }
  }

  /// Export presets to JSON string
  String exportPresetsToJson() {
    final presetsData =
        _presets.map((preset) {
          return {
            'id': preset.id,
            'name': preset.name,
            'filterGroups': preset.filterGroups.map(_filterGroupToMap).toList(),
            'createdAt': preset.createdAt.toIso8601String(),
            'updatedAt': preset.updatedAt.toIso8601String(),
            'description': preset.description,
            'isDefault': preset.isDefault,
          };
        }).toList();

    return jsonEncode(presetsData);
  }

  /// Import presets from JSON string
  Future<void> importPresetsFromJson(String json) async {
    try {
      final List<dynamic> presetsData = jsonDecode(json);

      final newPresets =
          presetsData.map((data) {
            return FilterPreset(
              id: data['id'],
              name: data['name'],
              filterGroups:
                  (data['filterGroups'] as List)
                      .map((group) => _mapToFilterGroup(group))
                      .toList(),
              createdAt: DateTime.parse(data['createdAt']),
              updatedAt: DateTime.parse(data['updatedAt']),
              description: data['description'],
              isDefault: data['isDefault'] ?? false,
            );
          }).toList();

      _presets = [..._presets, ...newPresets];
      await _savePresets();
      notifyListeners();
    } catch (e) {
      debugPrint('Error importing filter presets: $e');
      throw Exception('Invalid filter preset format');
    }
  }

  /// Convert a FilterGroup to a map
  Map<String, dynamic> _filterGroupToMap(FilterGroup group) {
    return {
      'criteria': group.criteria.map(_filterCriteriaToMap).toList(),
      'logic': group.logic.toString().split('.').last,
      'name': group.name,
    };
  }

  /// Convert a FilterCriteria to a map
  Map<String, dynamic> _filterCriteriaToMap(FilterCriteria criteria) {
    return {
      'field': criteria.field,
      'operator': criteria.operator.toString().split('.').last,
      'valueType': criteria.valueType.toString().split('.').last,
      'value': criteria.value,
      'secondaryValue': criteria.secondaryValue,
      'isActive': criteria.isActive,
    };
  }

  /// Convert a map to a FilterGroup
  FilterGroup _mapToFilterGroup(Map<String, dynamic> map) {
    return FilterGroup(
      criteria:
          (map['criteria'] as List)
              .map((c) => _mapToFilterCriteria(c))
              .toList(),
      logic: map['logic'] == 'or' ? FilterGroupLogic.or : FilterGroupLogic.and,
      name: map['name'],
    );
  }

  /// Convert a map to a FilterCriteria
  FilterCriteria _mapToFilterCriteria(Map<String, dynamic> map) {
    return FilterCriteria(
      field: map['field'],
      operator: _stringToOperator(map['operator']),
      valueType: _stringToValueType(map['valueType']),
      value: map['value'],
      secondaryValue: map['secondaryValue'],
      isActive: map['isActive'] ?? true,
    );
  }

  /// Convert a string to FilterOperator enum
  FilterOperator _stringToOperator(String operatorStr) {
    switch (operatorStr) {
      case 'equals':
        return FilterOperator.equals;
      case 'notEquals':
        return FilterOperator.notEquals;
      case 'contains':
        return FilterOperator.contains;
      case 'notContains':
        return FilterOperator.notContains;
      case 'startsWith':
        return FilterOperator.startsWith;
      case 'endsWith':
        return FilterOperator.endsWith;
      case 'greaterThan':
        return FilterOperator.greaterThan;
      case 'lessThan':
        return FilterOperator.lessThan;
      case 'greaterThanOrEquals':
        return FilterOperator.greaterThanOrEquals;
      case 'lessThanOrEquals':
        return FilterOperator.lessThanOrEquals;
      case 'between':
        return FilterOperator.between;
      case 'isIn':
        return FilterOperator.isIn;
      case 'notIn':
        return FilterOperator.notIn;
      case 'isNull':
        return FilterOperator.isNull;
      case 'isNotNull':
        return FilterOperator.isNotNull;
      default:
        return FilterOperator.equals;
    }
  }

  /// Convert a string to FilterValueType enum
  FilterValueType _stringToValueType(String typeStr) {
    switch (typeStr) {
      case 'text':
        return FilterValueType.text;
      case 'number':
        return FilterValueType.number;
      case 'date':
        return FilterValueType.date;
      case 'boolean':
        return FilterValueType.boolean;
      case 'relation':
        return FilterValueType.relation;
      default:
        return FilterValueType.text;
    }
  }

  /// Convert a preset to JSON string
  String _presetToJson(FilterPreset preset) {
    final Map<String, dynamic> data = {
      'id': preset.id,
      'name': preset.name,
      'filterGroups': preset.filterGroups.map(_filterGroupToMap).toList(),
      'createdAt': preset.createdAt.toIso8601String(),
      'updatedAt': preset.updatedAt.toIso8601String(),
      'description': preset.description,
      'isDefault': preset.isDefault,
    };

    return jsonEncode(data);
  }

  /// Convert JSON string to a preset
  FilterPreset _presetFromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);

    return FilterPreset(
      id: data['id'],
      name: data['name'],
      filterGroups:
          (data['filterGroups'] as List)
              .map((group) => _mapToFilterGroup(group))
              .toList(),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      description: data['description'],
      isDefault: data['isDefault'] ?? false,
    );
  }
}
