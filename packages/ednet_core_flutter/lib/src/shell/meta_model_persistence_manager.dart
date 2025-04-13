part of ednet_core_flutter;

/// Manages persistence for meta-model changes, allowing synchronization between generated code
/// and in-vivo model modifications.
///
/// This class tracks and persists changes to domain models made at runtime, creating a "diff"
/// between the original generated model and the current state. It also provides capabilities
/// to:
/// - Export model changes for code generation
/// - Detect and merge conflicts
/// - Create YAML representations of changes
/// - Load/save meta-model changes
class MetaModelPersistenceManager {
  /// The shell application containing domain models
  final ShellApp shellApp;

  /// Original domain definitions from the generated code
  final Map<String, Map<String, dynamic>> _originalDomainDefinitions = {};

  /// Current domain definitions including any in-vivo changes
  final Map<String, Map<String, dynamic>> _currentDomainDefinitions = {};

  /// Change history for tracking the evolution of the meta-model
  final List<MetaModelChangeRecord> _changeHistory = [];

  /// Constructor
  MetaModelPersistenceManager(this.shellApp) {
    // Initialize by capturing the current state of all domains
    _initializeOriginalDefinitions();
  }

  /// Initialize the original definitions from the current state
  void _initializeOriginalDefinitions() {
    try {
      // For multi-domain support
      if (shellApp.isMultiDomain && shellApp.domainManager != null) {
        final domainManager = shellApp.domainManager!;
        for (final domain in domainManager.domains) {
          _captureOriginalDomainDefinition(domain);
        }
      } else {
        // Single domain
        _captureOriginalDomainDefinition(shellApp.domain);
      }
    } catch (e) {
      debugPrint('Error initializing original definitions: $e');
    }
  }

  /// Capture the original definition of a domain
  void _captureOriginalDomainDefinition(Domain domain) {
    final domainDefinition = _serializeDomain(domain);
    _originalDomainDefinitions[domain.code] = domainDefinition;
    // Also set as the current definition initially
    _currentDomainDefinitions[domain.code] = Map.from(domainDefinition);
  }

  /// Create a serialized representation of a domain
  Map<String, dynamic> _serializeDomain(Domain domain) {
    return {
      'code': domain.code,
      'description': domain.description,
      'models': domain.models.map((model) => _serializeModel(model)).toList(),
    };
  }

  /// Create a serialized representation of a model
  Map<String, dynamic> _serializeModel(Model model) {
    return {
      'code': model.code,
      'description': model.description,
      'concepts':
          model.concepts.map((concept) => _serializeConcept(concept)).toList(),
    };
  }

  /// Create a serialized representation of a concept
  Map<String, dynamic> _serializeConcept(Concept concept) {
    return {
      'code': concept.code,
      'entry': concept.entry,
      'abstract': concept.abstract,
      'description': concept.description,
      'category': concept.category,
      'metadata': concept.metadata,
      'attributes': concept.attributes.map((a) {
        final Map<String, dynamic> attrData = {
          'code': a.code,
          'identifier': a.identifier,
          'required': a.required,
        };

        // Add type information if available
        if (a is Attribute && a.type != null) {
          attrData['type'] = a.type?.code;
        }

        // Add label if available
        if (a.label != null) {
          attrData['label'] = a.label;
        }

        return attrData;
      }).toList(),
      'parents': concept.parents.map((p) {
        final Map<String, dynamic> parentData = {
          'code': p.code,
          'identifier': p.identifier,
        };

        // Add Parent-specific properties
        if (p is Parent) {
          parentData['destinationConceptCode'] = p.destinationConcept.code;
          parentData['internal'] = p.internal;
        }

        // Add label if available
        if (p.label != null) {
          parentData['label'] = p.label;
        }

        return parentData;
      }).toList(),
      'children': concept.children.map((c) {
        final Map<String, dynamic> childData = {
          'code': c.code,
        };

        // Add Child-specific properties
        if (c is Child) {
          childData['destinationConceptCode'] = c.destinationConcept.code;
          childData['internal'] = c.internal;
        }

        // Add label if available
        if (c.label != null) {
          childData['label'] = c.label;
        }

        return childData;
      }).toList(),
    };
  }

  /// Record a change to the meta-model
  void recordChange(MetaModelChangeEvent event) {
    final timestamp = DateTime.now();
    final changeRecord = MetaModelChangeRecord(
      timestamp: timestamp,
      changeType: event.changeType,
      elementType: _getElementType(event.element),
      elementCode: _getElementCode(event.element),
      context: event.context,
    );

    _changeHistory.add(changeRecord);

    // Update current definition
    _updateCurrentDefinition(event);

    // Persist the change
    _persistChangeRecord(changeRecord);
  }

  /// Get the type of an element (domain, model, concept, etc.)
  String _getElementType(Object element) {
    if (element is Domain) return 'domain';
    if (element is Model) return 'model';
    if (element is Concept) return 'concept';
    if (element is Attribute) return 'attribute';
    if (element is Parent) return 'parent';
    if (element is Child) return 'child';
    return 'unknown';
  }

  /// Get the code of an element
  String _getElementCode(Object element) {
    if (element is Entity) return element.code ?? 'unnamed';
    return 'unnamed';
  }

  /// Update the current definition based on a change event
  void _updateCurrentDefinition(MetaModelChangeEvent event) {
    // Implementation depends on the change type
    if (event.changeType == 'concept_created' && event.element is Concept) {
      final concept = event.element as Concept;
      final model = concept.model;
      final domain = model.domain;

      // Get or create the domain definition
      final domainDefinition = _currentDomainDefinitions[domain.code] ??= {
        'code': domain.code,
        'description': domain.description,
        'models': [],
      };

      // Find or create the model entry
      List<Map<String, dynamic>> models =
          domainDefinition['models'] as List<Map<String, dynamic>>;
      Map<String, dynamic>? modelDefinition;

      for (final modelDef in models) {
        if (modelDef['code'] == model.code) {
          modelDefinition = modelDef;
          break;
        }
      }

      if (modelDefinition == null) {
        modelDefinition = {
          'code': model.code,
          'description': model.description,
          'concepts': [],
        };
        models.add(modelDefinition);
      }

      // Add the new concept
      List<Map<String, dynamic>> concepts =
          modelDefinition['concepts'] as List<Map<String, dynamic>>;
      concepts.add(_serializeConcept(concept));
    }

    // Other change types would be handled similarly
  }

  /// Persist a change record to storage
  Future<void> _persistChangeRecord(MetaModelChangeRecord record) async {
    try {
      // Convert to JSON
      final recordData = record.toJson();

      // Save to domain repository if persistence is available
      if (shellApp._persistence.hasDomainSession) {
        await shellApp.saveEntity('EDNetCoreModelChange', recordData);
      }
    } catch (e) {
      debugPrint('Error persisting change record: $e');
    }
  }

  /// Get the diff between original and current domain definitions
  Map<String, dynamic> getDomainModelDiff(String domainCode) {
    final original = _originalDomainDefinitions[domainCode];
    final current = _currentDomainDefinitions[domainCode];

    if (original == null || current == null) {
      return {};
    }

    return _calculateDiff(original, current);
  }

  /// Calculate the difference between two objects
  Map<String, dynamic> _calculateDiff(
      Map<String, dynamic> original, Map<String, dynamic> current) {
    final diff = <String, dynamic>{};

    // Find added, removed, and changed elements
    for (final key in {...original.keys, ...current.keys}) {
      if (!original.containsKey(key)) {
        // Added elements
        diff['added_$key'] = current[key];
      } else if (!current.containsKey(key)) {
        // Removed elements
        diff['removed_$key'] = original[key];
      } else if (original[key] != current[key]) {
        // Changed elements
        if (original[key] is Map && current[key] is Map) {
          // Recursive diff for nested maps
          diff[key] = _calculateDiff(
            original[key] as Map<String, dynamic>,
            current[key] as Map<String, dynamic>,
          );
        } else if (original[key] is List && current[key] is List) {
          // Diff for lists (more complex)
          diff[key] = _calculateListDiff(
            original[key] as List,
            current[key] as List,
          );
        } else {
          // Simple value change
          diff[key] = {
            'from': original[key],
            'to': current[key],
          };
        }
      }
    }

    return diff;
  }

  /// Calculate the difference between two lists
  Map<String, dynamic> _calculateListDiff(List original, List current) {
    final diff = <String, dynamic>{
      'added': <dynamic>[],
      'removed': <dynamic>[],
      'changed': <Map<String, dynamic>>[],
    };

    // This is a simplified implementation
    // For real use, would need a more sophisticated algorithm for list diffing
    // based on item identity/code

    // Find items in current that aren't in original (simplified)
    for (final item in current) {
      if (!_listContainsSimilarItem(original, item)) {
        (diff['added'] as List).add(item);
      }
    }

    // Find items in original that aren't in current (simplified)
    for (final item in original) {
      if (!_listContainsSimilarItem(current, item)) {
        (diff['removed'] as List).add(item);
      }
    }

    return diff;
  }

  /// Check if a list contains a similar item (by code if available)
  bool _listContainsSimilarItem(List list, dynamic item) {
    if (item is Map && item.containsKey('code')) {
      final code = item['code'];
      return list.any((element) =>
          element is Map &&
          element.containsKey('code') &&
          element['code'] == code);
    }
    return list.contains(item);
  }

  /// Export the current domain model to YAML format
  String exportToYaml(String domainCode) {
    final current = _currentDomainDefinitions[domainCode];
    if (current == null) {
      return '';
    }

    // Convert to YAML-friendly structure
    final yamlMap = _prepareForYaml(current);

    // Use the _convertToYamlString method since we can't import yaml package in a part file
    return _convertToYamlString(yamlMap);
  }

  /// Prepare a model for YAML export
  Map<String, dynamic> _prepareForYaml(Map<String, dynamic> modelData) {
    // Deep copy the model data to avoid modifying the original
    final result = Map<String, dynamic>.from(modelData);

    // Convert any internal representations to expected YAML schema
    if (result.containsKey('models') && result['models'] is List) {
      final List<dynamic> models = result['models'] as List<dynamic>;
      for (int i = 0; i < models.length; i++) {
        if (models[i] is Map) {
          final modelMap = models[i] as Map<String, dynamic>;
          // Process concept lists
          if (modelMap.containsKey('concepts') &&
              modelMap['concepts'] is List) {
            final List<dynamic> concepts =
                modelMap['concepts'] as List<dynamic>;
            for (int j = 0; j < concepts.length; j++) {
              if (concepts[j] is Map) {
                concepts[j] =
                    _prepareConceptForYaml(concepts[j] as Map<String, dynamic>);
              }
            }
          }
        }
      }
    }

    return result;
  }

  /// Prepare concept data for YAML export
  Map<String, dynamic> _prepareConceptForYaml(
      Map<String, dynamic> conceptData) {
    final result = Map<String, dynamic>.from(conceptData);

    // Clean up any null or empty values that shouldn't be in YAML
    if (result['metadata'] == null) {
      result.remove('metadata');
    }

    // Format relationships for better YAML representation
    if (result.containsKey('attributes') && result['attributes'] is List) {
      final List<dynamic> attributes = result['attributes'] as List<dynamic>;
      for (int i = 0; i < attributes.length; i++) {
        if (attributes[i] is Map) {
          final Map<String, dynamic> attr =
              attributes[i] as Map<String, dynamic>;
          // Remove null values
          attr.removeWhere((key, value) => value == null);
        }
      }
    }

    // Similar cleanup for parents and children
    ['parents', 'children'].forEach((relationship) {
      if (result.containsKey(relationship) && result[relationship] is List) {
        final List<dynamic> relations = result[relationship] as List<dynamic>;
        for (int i = 0; i < relations.length; i++) {
          if (relations[i] is Map) {
            final Map<String, dynamic> rel =
                relations[i] as Map<String, dynamic>;
            // Remove null values
            rel.removeWhere((key, value) => value == null);
          }
        }
      }
    });

    return result;
  }

  /// Convert a map to YAML string
  String _convertToYamlString(Map<String, dynamic> data) {
    // In a real implementation, use a YAML library
    // Simplified representation
    final buffer = StringBuffer();
    _writeYamlMap(buffer, data, 0);
    return buffer.toString();
  }

  /// Write a map to a YAML string with proper indentation
  void _writeYamlMap(
      StringBuffer buffer, Map<String, dynamic> map, int indent) {
    final indentStr = ' ' * indent;

    map.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('$indentStr$key:');
        _writeYamlMap(buffer, value as Map<String, dynamic>, indent + 2);
      } else if (value is List) {
        buffer.writeln('$indentStr$key:');
        for (final item in value) {
          if (item is Map) {
            buffer.writeln('$indentStr- ');
            _writeYamlMap(buffer, item as Map<String, dynamic>, indent + 4);
          } else {
            buffer.writeln('$indentStr- $item');
          }
        }
      } else {
        buffer.writeln('$indentStr$key: $value');
      }
    });
  }

  /// Load model changes from persistence
  Future<void> loadModelChanges() async {
    try {
      if (shellApp._persistence.hasDomainSession) {
        final changes = await shellApp.loadEntities('EDNetCoreModelChange');

        // Clear existing change history
        _changeHistory.clear();

        // Apply changes in order
        for (final change in changes) {
          final record = MetaModelChangeRecord.fromJson(change);
          _changeHistory.add(record);

          // Apply change to current definition
          _applyChangeToCurrentDefinition(record);
        }
      }
    } catch (e) {
      debugPrint('Error loading model changes: $e');
    }
  }

  /// Apply a change record to the current definition
  void _applyChangeToCurrentDefinition(MetaModelChangeRecord record) {
    switch (record.changeType) {
      case 'concept_created':
        _applyConceptCreated(record);
        break;
      case 'attribute_added':
        _applyAttributeAdded(record);
        break;
      case 'relationship_added':
        _applyRelationshipAdded(record);
        break;
      case 'model_created':
        _applyModelCreated(record);
        break;
      case 'conflict_resolution':
        // Conflicts are already reflected in the current definition
        break;
      default:
        debugPrint('Unknown change type: ${record.changeType}');
    }
  }

  /// Apply a concept_created change
  void _applyConceptCreated(MetaModelChangeRecord record) {
    final conceptCode = record.elementCode;
    final domainCode = record.context['domainCode'] as String? ??
        _findDomainCodeForConcept(conceptCode);
    final modelCode = record.context['modelCode'] as String? ??
        _findModelCodeForConcept(conceptCode);

    if (domainCode == null || modelCode == null) {
      debugPrint(
          'Cannot apply concept_created change: missing domain or model code');
      return;
    }

    // Get or create domain definition
    final domainDef = _currentDomainDefinitions[domainCode] ??= {
      'code': domainCode,
      'description': record.context['domainDescription'] as String? ??
          'Domain $domainCode',
      'models': [],
    };

    // Find or create model definition
    List<dynamic> models = domainDef['models'] as List<dynamic>;
    Map<String, dynamic>? modelDef;

    for (final model in models) {
      if (model is Map && model['code'] == modelCode) {
        modelDef = model as Map<String, dynamic>;
        break;
      }
    }

    if (modelDef == null) {
      modelDef = {
        'code': modelCode,
        'description':
            record.context['modelDescription'] as String? ?? 'Model $modelCode',
        'concepts': [],
      };
      models.add(modelDef);
    }

    // Create concept definition
    final conceptDef = {
      'code': conceptCode,
      'entry': record.context['entry'] as bool? ?? false,
      'abstract': record.context['abstract'] as bool? ?? false,
      'description':
          record.context['description'] as String? ?? 'Concept $conceptCode',
      'category': record.context['category'] as String?,
      'metadata': record.context['metadata'] as Map<String, dynamic>?,
      'attributes': <dynamic>[],
      'parents': <dynamic>[],
      'children': <dynamic>[],
    };

    // Add to concepts list
    List<dynamic> concepts = modelDef['concepts'] as List<dynamic>;
    concepts.add(conceptDef);
  }

  /// Apply an attribute_added change
  void _applyAttributeAdded(MetaModelChangeRecord record) {
    final conceptCode = record.elementCode;
    final attributeData = record.context['attribute'] as Map<String, dynamic>?;

    if (attributeData == null) {
      debugPrint('Cannot apply attribute_added change: missing attribute data');
      return;
    }

    // Find the concept
    final conceptDef = _findConceptDefinition(conceptCode);
    if (conceptDef == null) {
      debugPrint('Cannot apply attribute_added change: concept not found');
      return;
    }

    // Add attribute to concept
    List<dynamic> attributes = conceptDef['attributes'] as List<dynamic>;
    attributes.add(attributeData);
  }

  /// Apply a relationship_added change
  void _applyRelationshipAdded(MetaModelChangeRecord record) {
    final conceptCode = record.elementCode;
    final relationshipType = record.context['relationship_type'] as String?;
    final relationshipData =
        record.context['relationship'] as Map<String, dynamic>?;

    if (relationshipType == null || relationshipData == null) {
      debugPrint(
          'Cannot apply relationship_added change: missing relationship data');
      return;
    }

    // Find the concept
    final conceptDef = _findConceptDefinition(conceptCode);
    if (conceptDef == null) {
      debugPrint('Cannot apply relationship_added change: concept not found');
      return;
    }

    // Add relationship to concept
    if (relationshipType == 'parent') {
      List<dynamic> parents = conceptDef['parents'] as List<dynamic>;
      parents.add(relationshipData);
    } else if (relationshipType == 'child') {
      List<dynamic> children = conceptDef['children'] as List<dynamic>;
      children.add(relationshipData);
    }
  }

  /// Apply a model_created change
  void _applyModelCreated(MetaModelChangeRecord record) {
    final modelCode = record.elementCode;
    final domainCode = record.context['domainCode'] as String?;

    if (domainCode == null) {
      debugPrint('Cannot apply model_created change: missing domain code');
      return;
    }

    // Get or create domain definition
    final domainDef = _currentDomainDefinitions[domainCode] ??= {
      'code': domainCode,
      'description': record.context['domainDescription'] as String? ??
          'Domain $domainCode',
      'models': [],
    };

    // Create model definition
    final modelDef = {
      'code': modelCode,
      'description':
          record.context['description'] as String? ?? 'Model $modelCode',
      'concepts': <dynamic>[],
    };

    // Add to models list
    List<dynamic> models = domainDef['models'] as List<dynamic>;
    models.add(modelDef);
  }

  /// Find a concept definition in the current definitions
  Map<String, dynamic>? _findConceptDefinition(String conceptCode) {
    for (final domainDef in _currentDomainDefinitions.values) {
      final models = domainDef['models'] as List<dynamic>;
      for (final model in models) {
        if (model is Map) {
          final concepts = model['concepts'] as List<dynamic>;
          for (final concept in concepts) {
            if (concept is Map && concept['code'] == conceptCode) {
              return concept as Map<String, dynamic>;
            }
          }
        }
      }
    }
    return null;
  }

  /// Find domain code for a concept
  String? _findDomainCodeForConcept(String conceptCode) {
    for (final entry in _currentDomainDefinitions.entries) {
      final domainCode = entry.key;
      final domainDef = entry.value;
      final models = domainDef['models'] as List<dynamic>;
      for (final model in models) {
        if (model is Map) {
          final concepts = model['concepts'] as List<dynamic>;
          for (final concept in concepts) {
            if (concept is Map && concept['code'] == conceptCode) {
              return domainCode;
            }
          }
        }
      }
    }
    return null;
  }

  /// Find model code for a concept
  String? _findModelCodeForConcept(String conceptCode) {
    for (final domainDef in _currentDomainDefinitions.values) {
      final models = domainDef['models'] as List<dynamic>;
      for (final model in models) {
        if (model is Map) {
          final modelCode = model['code'] as String;
          final concepts = model['concepts'] as List<dynamic>;
          for (final concept in concepts) {
            if (concept is Map && concept['code'] == conceptCode) {
              return modelCode;
            }
          }
        }
      }
    }
    return null;
  }

  /// Save current domain model as a new baseline
  Future<void> saveAsBaseline(String domainCode) async {
    try {
      final current = _currentDomainDefinitions[domainCode];
      if (current == null) return;

      // Update original definition to match current
      _originalDomainDefinitions[domainCode] = Map.from(current);

      // Persist as baseline
      if (shellApp._persistence.hasDomainSession) {
        await shellApp.saveEntity('EDNetCoreModelBaseline', {
          'domainCode': domainCode,
          'timestamp': DateTime.now().toIso8601String(),
          'definition': current,
        });
      }

      // Clear change history related to this domain
      _changeHistory.removeWhere((record) =>
          record.elementType == 'domain' && record.elementCode == domainCode ||
          record.context['domainCode'] == domainCode);
    } catch (e) {
      debugPrint('Error saving baseline: $e');
    }
  }

  /// Handle conflicts with generated models after code regeneration
  Future<void> handleCodeRegenerationConflicts(Domain regeneratedDomain) async {
    // Create a definition for the regenerated domain
    final regeneratedDefinition = _serializeDomain(regeneratedDomain);

    // Get the current definition
    final currentDefinition = _currentDomainDefinitions[regeneratedDomain.code];
    if (currentDefinition == null) {
      // No current definition, just use the regenerated one
      _originalDomainDefinitions[regeneratedDomain.code] =
          regeneratedDefinition;
      _currentDomainDefinitions[regeneratedDomain.code] =
          Map.from(regeneratedDefinition);
      return;
    }

    // Calculate conflicts
    final conflicts = _calculateDiff(regeneratedDefinition, currentDefinition);

    // Handle conflicts
    // This would typically involve user interaction to resolve conflicts
    // For now, we'll just keep the current changes as a delta

    // Update the original definition to the regenerated one
    _originalDomainDefinitions[regeneratedDomain.code] = regeneratedDefinition;

    // Record the conflict resolution
    final timestamp = DateTime.now();
    final changeRecord = MetaModelChangeRecord(
      timestamp: timestamp,
      changeType: 'conflict_resolution',
      elementType: 'domain',
      elementCode: regeneratedDomain.code,
      context: {
        'conflicts': conflicts,
      },
    );

    _changeHistory.add(changeRecord);
    _persistChangeRecord(changeRecord);
  }

  /// Export model diff to JSON string
  String exportDiffToJson(String domainCode) {
    final diff = getDomainModelDiff(domainCode);
    if (diff.isEmpty) {
      return '{}';
    }
    return jsonEncode(diff);
  }

  /// Import model diff from JSON string and apply changes
  Future<bool> importDiffFromJson(String domainCode, String jsonDiff) async {
    try {
      if (jsonDiff.trim().isEmpty) {
        return false;
      }

      final diff = jsonDecode(jsonDiff) as Map<String, dynamic>;
      if (diff.isEmpty) {
        return false;
      }

      // Get original domain
      final originalDef = _originalDomainDefinitions[domainCode];
      if (originalDef == null) {
        debugPrint('Cannot apply diff: original domain definition not found');
        return false;
      }

      // Apply diff to create new current definition
      final newCurrentDef = _applyDiffToDefinition(originalDef, diff);

      // Update current definition
      _currentDomainDefinitions[domainCode] = newCurrentDef;

      // Create change record for the import operation
      final changeRecord = MetaModelChangeRecord(
        timestamp: DateTime.now(),
        changeType: 'diff_imported',
        elementType: 'domain',
        elementCode: domainCode,
        context: {'diff_size': utf8.encode(jsonDiff).length},
      );

      _changeHistory.add(changeRecord);
      await _persistChangeRecord(changeRecord);

      // Notify shell app
      if (shellApp.domainManager != null) {
        // Reload domain from the modified definition
        await _reloadDomainFromDefinition(domainCode, newCurrentDef);
      }

      return true;
    } catch (e) {
      debugPrint('Error importing diff: $e');
      return false;
    }
  }

  /// Apply a diff to a domain definition
  Map<String, dynamic> _applyDiffToDefinition(
      Map<String, dynamic> original, Map<String, dynamic> diff) {
    // Create a deep copy of the original to modify
    final result = _deepCopy(original);

    // Apply each diff element
    for (final key in diff.keys) {
      if (key.startsWith('added_')) {
        // Handle added elements
        final actualKey = key.substring(6); // Remove 'added_' prefix
        result[actualKey] = diff[key];
      } else if (key.startsWith('removed_')) {
        // Handle removed elements
        final actualKey = key.substring(8); // Remove 'removed_' prefix
        result.remove(actualKey);
      } else {
        // Handle changed elements
        final value = diff[key];
        if (value is Map) {
          if (value.containsKey('from') && value.containsKey('to')) {
            // Simple value change
            result[key] = value['to'];
          } else if (result[key] is Map) {
            // Recursive changes to nested map
            result[key] = _applyDiffToDefinition(
                result[key] as Map<String, dynamic>,
                value as Map<String, dynamic>);
          } else if (result[key] is List &&
              value.containsKey('added') &&
              value.containsKey('removed')) {
            // List changes
            result[key] = _applyListDiff(
                result[key] as List, value as Map<String, dynamic>);
          }
        }
      }
    }

    return result;
  }

  /// Apply changes to a list
  List _applyListDiff(List original, Map<String, dynamic> diff) {
    // Create a copy of the original list
    final result = List.from(original);

    // Apply removals
    if (diff.containsKey('removed') && diff['removed'] is List) {
      final removals = diff['removed'] as List;
      for (final item in removals) {
        // Remove matching items
        result.removeWhere((element) => _areListItemsEqual(element, item));
      }
    }

    // Apply additions
    if (diff.containsKey('added') && diff['added'] is List) {
      final additions = diff['added'] as List;
      result.addAll(additions);
    }

    // Apply changes (not implemented in this simple version)

    return result;
  }

  /// Check if two list items are equal (by code or direct equality)
  bool _areListItemsEqual(dynamic item1, dynamic item2) {
    if (item1 is Map && item2 is Map) {
      if (item1.containsKey('code') && item2.containsKey('code')) {
        return item1['code'] == item2['code'];
      }
    }
    return item1 == item2;
  }

  /// Create a deep copy of a map
  Map<String, dynamic> _deepCopy(Map<String, dynamic> original) {
    final String json = jsonEncode(original);
    return jsonDecode(json) as Map<String, dynamic>;
  }

  /// Reload a domain from a modified definition
  Future<void> _reloadDomainFromDefinition(
      String domainCode, Map<String, dynamic> definition) async {
    try {
      final domainManager = shellApp.domainManager;
      if (domainManager == null) return;

      // Find the domain
      Domain? domain;
      for (final d in domainManager.domains) {
        if (d.code == domainCode) {
          domain = d;
          break;
        }
      }

      if (domain == null) return;

      // For now, we'll just force a full shell app refresh
      // In a real implementation, we would need to carefully update the in-memory domain
      shellApp.notifyListeners();

      // Force navigation refresh if available
      if (shellApp.navigationService != null) {
        shellApp.navigationService.notifyListeners();
      }
    } catch (e) {
      debugPrint('Error reloading domain: $e');
    }
  }

  /// Load a domain model diff from a file
  Future<String> loadDiffFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw EDNetException('Diff file does not exist: $filePath');
      }

      return await file.readAsString();
    } catch (e) {
      debugPrint('Error loading diff from file: $e');
      return '';
    }
  }

  /// Save a domain model diff to a file
  Future<bool> saveDiffToFile(String domainCode, String filePath) async {
    try {
      final diff = exportDiffToJson(domainCode);
      if (diff == '{}') {
        return false; // No diff to save
      }

      final file = File(filePath);
      await file.writeAsString(diff);
      return true;
    } catch (e) {
      debugPrint('Error saving diff to file: $e');
      return false;
    }
  }
}

/// Record of a change to the meta-model
class MetaModelChangeRecord {
  /// When the change occurred
  final DateTime timestamp;

  /// Type of change (created, modified, deleted)
  final String changeType;

  /// Type of element affected (domain, model, concept, etc.)
  final String elementType;

  /// Code of the element affected
  final String elementCode;

  /// Additional context data
  final Map<String, dynamic> context;

  /// Constructor
  MetaModelChangeRecord({
    required this.timestamp,
    required this.changeType,
    required this.elementType,
    required this.elementCode,
    this.context = const {},
  });

  /// Convert to JSON representation
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'changeType': changeType,
      'elementType': elementType,
      'elementCode': elementCode,
      'context': context,
    };
  }

  /// Create from JSON representation
  static MetaModelChangeRecord fromJson(Map<String, dynamic> json) {
    return MetaModelChangeRecord(
      timestamp: DateTime.parse(json['timestamp'] as String),
      changeType: json['changeType'] as String,
      elementType: json['elementType'] as String,
      elementCode: json['elementCode'] as String,
      context: json['context'] as Map<String, dynamic>? ?? {},
    );
  }
}
