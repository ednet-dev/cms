part of ednet_core_flutter;

/// Manages meta-model operations for the shell application, allowing in-vivo domain model editing
class MetaModelManager {
  /// The shell application containing domain models
  final ShellApp shellApp;

  /// Event controller to notify listeners of meta-model changes
  final _metaModelChangeController =
      StreamController<MetaModelChangeEvent>.broadcast();

  /// Stream of meta-model change events
  Stream<MetaModelChangeEvent> get onMetaModelChanged =>
      _metaModelChangeController.stream;

  /// Constructor
  MetaModelManager(this.shellApp);

  /// Create a new concept in a model
  Future<Concept> createConcept(
    Model model,
    String conceptCode, {
    bool entry = false,
    bool abstract = false,
    String? description,
    String? category,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Create the concept
      final concept = Concept(model, conceptCode);

      // Set additional properties
      concept.entry = entry;
      concept.abstract = abstract;
      concept.description =
          description ?? 'Concept created via MetaModelManager';

      if (category != null) {
        concept.category = category;
      }

      if (metadata != null) {
        concept.metadata = metadata;
      }

      // Notify listeners
      _metaModelChangeController
          .add(MetaModelChangeEvent.conceptCreated(concept));

      // Save concept definition to persistence (if supported)
      await _persistConceptDefinition(concept);

      return concept;
    } catch (e) {
      debugPrint('Error creating concept: $e');
      rethrow;
    }
  }

  /// Add an attribute to a concept
  Future<Attribute> addAttribute(
    Concept concept,
    String attributeCode,
    String typeCode, {
    bool identifier = false,
    bool required = false,
    Object? defaultValue,
    String? description,
  }) async {
    try {
      // Create the attribute
      final attribute = Attribute(concept, attributeCode);

      // Set attribute properties - find the type from domain
      final attributeType = concept.model.domain.getType(typeCode);
      attribute.type = attributeType;
      attribute.identifier = identifier;
      attribute.required = required;

      // These properties need to be handled differently as they don't have direct setters
      // We'll manage default value and description through custom properties if needed
      if (description != null) {
        // For description, store in the metadata if it supports it
        try {
          // Use setAttribute technique if available on attributes
          attribute.setAttribute('description', description as Object);
        } catch (e) {
          // Ignore if not available
        }
      }

      // Add to concept attributes
      concept.attributes.add(attribute);

      // Notify listeners
      _metaModelChangeController
          .add(MetaModelChangeEvent.attributeAdded(concept, attribute));

      // Persist changes
      await _persistConceptDefinition(concept);

      return attribute;
    } catch (e) {
      debugPrint('Error adding attribute: $e');
      rethrow;
    }
  }

  /// Add a parent relationship to a concept
  Future<Parent> addParent(
    Concept sourceConcept,
    Concept destinationConcept,
    String parentCode, {
    bool internal = false,
    bool identifier = false,
    String? description,
  }) async {
    try {
      // Create parent relationship
      final parent = Parent(sourceConcept, destinationConcept, parentCode);

      // Set parent properties
      parent.internal = internal;
      parent.identifier = identifier;

      // Handle description through custom means
      if (description != null) {
        // Store in associated properties or metadata
        try {
          // Try using setAttribute if available
          parent.setAttribute('description', description as Object);
        } catch (e) {
          // Fallback to label if possible
          // Not all Property subclasses have setters for label, handle carefully
          try {
            // On Parent objects, we know label is a String?
            if (parent.label != null || parent.label == null) {
              parent.label = description;
            }
          } catch (e) {
            // Ignore if not available
          }
        }
      }

      // Add to concept parents
      sourceConcept.parents.add(parent);

      // Create corresponding child in the destination concept
      final childCode = '${sourceConcept.codes}';
      final child = Child(destinationConcept, sourceConcept, childCode);
      child.internal = internal;
      destinationConcept.children.add(child);

      // Notify listeners
      _metaModelChangeController.add(MetaModelChangeEvent.relationshipAdded(
          sourceConcept, 'parent', parent));

      // Persist changes
      await _persistConceptDefinition(sourceConcept);
      await _persistConceptDefinition(destinationConcept);

      return parent;
    } catch (e) {
      debugPrint('Error adding parent relationship: $e');
      rethrow;
    }
  }

  /// Add a child relationship to a concept
  Future<Child> addChild(
    Concept sourceConcept,
    Concept destinationConcept,
    String childCode, {
    bool internal = false,
    String? description,
  }) async {
    try {
      // Create child relationship
      final child = Child(sourceConcept, destinationConcept, childCode);

      // Set child properties
      child.internal = internal;

      // Handle description through custom means
      if (description != null) {
        // Store in associated properties or metadata
        try {
          // Try using setAttribute if available
          child.setAttribute('description', description as Object);
        } catch (e) {
          // Fallback to label if possible
          // Not all Property subclasses have setters for label, handle carefully
          try {
            // On Child objects, we know label is a String?
            if (child.label != null || child.label == null) {
              child.label = description;
            }
          } catch (e) {
            // Ignore if not available
          }
        }
      }

      // Add to concept children
      sourceConcept.children.add(child);

      // Create corresponding parent in the destination concept
      final parentCode = '${sourceConcept.code}';
      final parent = Parent(destinationConcept, sourceConcept, parentCode);
      parent.internal = internal;
      destinationConcept.parents.add(parent);

      // Notify listeners
      _metaModelChangeController.add(MetaModelChangeEvent.relationshipAdded(
          sourceConcept, 'child', child));

      // Persist changes
      await _persistConceptDefinition(sourceConcept);
      await _persistConceptDefinition(destinationConcept);

      return child;
    } catch (e) {
      debugPrint('Error adding child relationship: $e');
      rethrow;
    }
  }

  /// Create a new model in a domain
  Future<Model> createModel(
    Domain domain,
    String modelCode, {
    String? description,
  }) async {
    try {
      // Create the model
      final model = Model(domain, modelCode);

      if (description != null) {
        model.description = description;
      }

      // Add to domain models
      domain.models.add(model);

      // Notify listeners
      _metaModelChangeController.add(MetaModelChangeEvent.modelCreated(model));

      // Persist changes to domain definition
      await _persistDomainDefinition(domain);

      return model;
    } catch (e) {
      debugPrint('Error creating model: $e');
      rethrow;
    }
  }

  /// Find or create a concept
  Future<Concept> findOrCreateConcept(
    Model model,
    String conceptCode, {
    bool entry = false,
    bool abstract = false,
    String? description,
  }) async {
    // Try to find existing concept
    for (final concept in model.concepts) {
      if (concept.code == conceptCode) {
        return concept;
      }
    }

    // Create a new concept if not found
    return await createConcept(
      model,
      conceptCode,
      entry: entry,
      abstract: abstract,
      description: description,
    );
  }

  /// Persist concept definition to storage (implementation depends on persistence strategy)
  Future<void> _persistConceptDefinition(Concept concept) async {
    try {
      // For development mode, serialize to JSON and save
      final Map<String, dynamic> conceptData = {
        'code': concept.code,
        'entry': concept.entry,
        'abstract': concept.abstract,
        'description': concept.description,
        'category': concept.category,
        'metadata': concept.metadata,
        'attributes': concept.attributes.map((a) {
          final attrData = <String, dynamic>{
            'code': a.code,
            'identifier': a.identifier,
            'required': a.required,
          };

          // Handle type safely
          if (a is Attribute && a.type != null) {
            // Get type code if available
            final typeCode = a.type?.code;
            if (typeCode != null) {
              attrData['type'] = typeCode;
            }
          }

          // Add label if available
          if (a.label != null) {
            attrData['label'] = a.label;
          }

          return attrData;
        }).toList(),
        'parents': concept.parents.map((p) {
          final parentData = <String, dynamic>{
            'code': p.code,
            'identifier': p.identifier,
          };

          // Handle destinationConcept safely for Parent type
          if (p is Parent) {
            parentData['destinationConceptCode'] = p.destinationConcept.code;
            // Handle internal as a bool, not String
            parentData['internal'] = p.internal;
          }

          // Add label if available
          if (p.label != null) {
            parentData['label'] = p.label;
          }

          return parentData;
        }).toList(),
        'children': concept.children.map((c) {
          final childData = <String, dynamic>{
            'code': c.code,
          };

          // Handle destinationConcept safely for Child type
          if (c is Child) {
            childData['destinationConceptCode'] = c.destinationConcept.code;
            // Handle internal as a bool, not String
            childData['internal'] = c.internal;
          }

          // Add label if available
          if (c.label != null) {
            childData['label'] = c.label;
          }

          return childData;
        }).toList(),
      };

      // Save to domain repository if persistence is available
      if (shellApp._persistence.hasDomainSession) {
        await shellApp.saveEntity('EDNetCoreConcept', conceptData);
      }
    } catch (e) {
      debugPrint('Error persisting concept definition: $e');
    }
  }

  /// Persist domain definition to storage
  Future<void> _persistDomainDefinition(Domain domain) async {
    try {
      // For development mode, serialize to JSON and save
      final Map<String, dynamic> domainData = {
        'code': domain.code,
        'description': domain.description,
        'models': domain.models
            .map((m) => {
                  'code': m.code,
                  'description': m.description,
                })
            .toList(),
      };

      // Save to domain repository if persistence is available
      if (shellApp._persistence.hasDomainSession) {
        await shellApp.saveEntity('EDNetCoreDomain', domainData);
      }
    } catch (e) {
      debugPrint('Error persisting domain definition: $e');
    }
  }

  /// Reload domain model after changes
  Future<void> reloadDomainModel() async {
    // Notify shell app that domain model has changed
    shellApp.notifyListeners();

    // Force navigation refresh if available
    if (shellApp.navigationService != null) {
      shellApp.navigationService.notifyListeners();
    }
  }

  /// Save the current domain model changes as a diff file
  Future<bool> saveDomainModelDiff(String domainCode, String filePath) async {
    try {
      if (shellApp._persistence == null) {
        debugPrint('Cannot save diff: persistence not available');
        return false;
      }

      // Get access to the persistence manager
      if (!_hasPersistenceManager()) {
        debugPrint(
            'Cannot save diff: meta model persistence manager not available');
        return false;
      }

      final persistenceManager = _getPersistenceManager();
      return await persistenceManager.saveDiffToFile(domainCode, filePath);
    } catch (e) {
      debugPrint('Error saving domain model diff: $e');
      return false;
    }
  }

  /// Load and apply a domain model diff from a file
  Future<bool> loadDomainModelDiff(String domainCode, String filePath) async {
    try {
      if (shellApp._persistence == null) {
        debugPrint('Cannot load diff: persistence not available');
        return false;
      }

      // Get access to the persistence manager
      if (!_hasPersistenceManager()) {
        debugPrint(
            'Cannot load diff: meta model persistence manager not available');
        return false;
      }

      final persistenceManager = _getPersistenceManager();
      final diffJson = await persistenceManager.loadDiffFromFile(filePath);
      if (diffJson.isEmpty) {
        return false;
      }

      final result =
          await persistenceManager.importDiffFromJson(domainCode, diffJson);

      // If successful, notify listeners to refresh UI
      if (result) {
        _metaModelChangeController.add(
          MetaModelChangeEvent('diff_applied', shellApp.domain, {
            'domainCode': domainCode,
            'source': filePath,
          }),
        );

        // Force model reload
        await reloadDomainModel();
      }

      return result;
    } catch (e) {
      debugPrint('Error loading domain model diff: $e');
      return false;
    }
  }

  /// Export the current domain model diff to a JSON string
  String exportDomainModelDiffToJson(String domainCode) {
    try {
      if (!_hasPersistenceManager()) {
        debugPrint(
            'Cannot export diff: meta model persistence manager not available');
        return '{}';
      }

      final persistenceManager = _getPersistenceManager();
      return persistenceManager.exportDiffToJson(domainCode);
    } catch (e) {
      debugPrint('Error exporting domain model diff: $e');
      return '{}';
    }
  }

  /// Import a domain model diff from a JSON string
  Future<bool> importDomainModelDiffFromJson(
      String domainCode, String jsonDiff) async {
    try {
      if (!_hasPersistenceManager()) {
        debugPrint(
            'Cannot import diff: meta model persistence manager not available');
        return false;
      }

      final persistenceManager = _getPersistenceManager();
      final result =
          await persistenceManager.importDiffFromJson(domainCode, jsonDiff);

      // If successful, notify listeners to refresh UI
      if (result) {
        _metaModelChangeController.add(
          MetaModelChangeEvent('diff_applied', shellApp.domain, {
            'domainCode': domainCode,
            'source': 'json_string',
          }),
        );

        // Force model reload
        await reloadDomainModel();
      }

      return result;
    } catch (e) {
      debugPrint('Error importing domain model diff: $e');
      return false;
    }
  }

  /// Check if the persistence manager is available
  bool _hasPersistenceManager() {
    return shellApp._persistence != null &&
        shellApp._persistence.hasDomainSession;
  }

  /// Get the persistence manager
  MetaModelPersistenceManager _getPersistenceManager() {
    if (!_hasPersistenceManager()) {
      throw EDNetException('Meta model persistence manager not available');
    }

    // Return the persistence manager from the shell app
    return shellApp.metaModelPersistenceManager;
  }

  /// Dispose resources
  void dispose() {
    _metaModelChangeController.close();
  }
}

/// Event class for meta-model changes
class MetaModelChangeEvent {
  /// The type of change
  final String changeType;

  /// The model element affected (concept, model, domain)
  final Object element;

  /// Additional context data
  final Map<String, dynamic> context;

  /// Constructor
  MetaModelChangeEvent(this.changeType, this.element,
      [this.context = const {}]);

  /// Create a concept created event
  static MetaModelChangeEvent conceptCreated(Concept concept) {
    return MetaModelChangeEvent('concept_created', concept);
  }

  /// Create a model created event
  static MetaModelChangeEvent modelCreated(Model model) {
    return MetaModelChangeEvent('model_created', model);
  }

  /// Create an attribute added event
  static MetaModelChangeEvent attributeAdded(
      Concept concept, Attribute attribute) {
    return MetaModelChangeEvent('attribute_added', concept, {
      'attribute': attribute,
    });
  }

  /// Create a relationship added event
  static MetaModelChangeEvent relationshipAdded(
      Concept concept, String relationType, dynamic relationship) {
    return MetaModelChangeEvent('relationship_added', concept, {
      'relationship_type': relationType,
      'relationship': relationship,
    });
  }
}
