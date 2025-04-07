part of ednet_core_flutter;

/// Base interface for UX adapters that transform domain entities into UI components
abstract class UXAdapter {
  /// The entity being adapted
  Entity get entity;

  /// Build a form for editing the entity
  Widget buildForm(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  });

  /// Build a list item representing the entity in a list
  Widget buildListItem(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.minimal,
  });

  /// Build a detailed view of the entity
  Widget buildDetailView(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  });

  /// Build a visualization of the entity
  Widget buildVisualization(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  });

  /// Get field descriptors for building a form
  List<UXFieldDescriptor> getFieldDescriptors({
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  });

  /// Get initial data for a form
  Map<String, dynamic> getInitialFormData();

  /// Submit form data and update the entity
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    // Default implementation - override in subclasses
    return true;
  }

  /// Get entity metadata for UI customization
  Map<String, dynamic> getMetadata() => {
        'entityType': entity.concept.code,
        'entityId': entity.id?.toString(),
      };
}

/// Factory for creating UX adapters for specific entity types
abstract class UXAdapterFactory<T extends Entity<T>> {
  /// Create an adapter for the given entity
  UXAdapter create(T entity);
}

/// A registry for UI adapters
class UXAdapterRegistry {
  // Singleton instance
  static final UXAdapterRegistry _instance = UXAdapterRegistry._internal();

  // Private constructor
  UXAdapterRegistry._internal();

  // Factory constructor
  factory UXAdapterRegistry() => _instance;

  // Maps entity types to adapter factories
  final Map<Type, UXAdapterFactory> _adapterFactories = {};

  // Maps entity types and disclosure levels to specialized adapters
  final Map<Type, Map<DisclosureLevel, UXAdapterFactory>>
      _disclosureLevelAdapters = {};

  // Maps concept codes to adapter factories
  final Map<String, UXAdapterFactory> _conceptAdapterFactories = {};

  // Maps concept codes and disclosure levels to specialized adapters
  final Map<String, Map<DisclosureLevel, UXAdapterFactory>>
      _conceptDisclosureLevelAdapters = {};

  /// Register an adapter factory for an entity type
  void register<T extends Entity<T>>(UXAdapterFactory<T> factory) {
    _adapterFactories[T] = factory;
  }

  /// Register an adapter dynamically using the Type object
  /// This is used when we don't know the concrete type at compile time
  void registerDynamic(Type entityType, UXAdapterFactory factory) {
    _adapterFactories[entityType] = factory;
  }

  /// Register an adapter factory for a specific disclosure level
  void registerWithDisclosure<T extends Entity<T>>(
    UXAdapterFactory<T> factory,
    DisclosureLevel level,
  ) {
    _disclosureLevelAdapters
        .putIfAbsent(T, () => {})
        .putIfAbsent(level, () => factory);
  }

  /// Register an adapter factory for a concept code
  void registerByConceptCode(
    String conceptCode,
    UXAdapterFactory factory, {
    DisclosureLevel? disclosureLevel,
  }) {
    if (disclosureLevel != null) {
      _conceptDisclosureLevelAdapters
          .putIfAbsent(conceptCode, () => {})
          .putIfAbsent(disclosureLevel, () => factory);
    } else {
      _conceptAdapterFactories[conceptCode] = factory;
    }
  }

  /// Get an adapter based on concept code
  UXAdapter getAdapterByConceptCode(
    Entity entity,
    String conceptCode, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    UXAdapterFactory? factory;

    // Try to find a disclosure-level specific adapter for this concept
    if (_conceptDisclosureLevelAdapters.containsKey(conceptCode)) {
      final levelAdapters = _conceptDisclosureLevelAdapters[conceptCode]!;

      // Find the highest appropriate disclosure level
      DisclosureLevel? selectedLevel;
      for (final level in levelAdapters.keys) {
        if (level.index <= disclosureLevel.index &&
            (selectedLevel == null || level.index > selectedLevel.index)) {
          selectedLevel = level;
        }
      }

      // If we found a suitable adapter, use it
      if (selectedLevel != null) {
        factory = levelAdapters[selectedLevel];
      }
    }

    // Try general concept adapter if no disclosure-level specific one was found
    if (factory == null && _conceptAdapterFactories.containsKey(conceptCode)) {
      factory = _conceptAdapterFactories[conceptCode];
    }

    // If we found a factory, use it
    if (factory != null) {
      return factory.create(entity);
    }

    // Fall back to using entity type-based adapter
    final entityType = entity.runtimeType;

    // Check for a disclosure-level specific adapter
    if (_disclosureLevelAdapters.containsKey(entityType)) {
      final levelAdapters = _disclosureLevelAdapters[entityType]!;

      // Find the highest appropriate disclosure level
      DisclosureLevel? selectedLevel;
      for (final level in levelAdapters.keys) {
        if (level.index <= disclosureLevel.index &&
            (selectedLevel == null || level.index > selectedLevel.index)) {
          selectedLevel = level;
        }
      }

      // If we found a suitable adapter, use it
      if (selectedLevel != null) {
        final factory = levelAdapters[selectedLevel]!;
        return factory.create(entity);
      }
    }

    // Otherwise use the standard adapter
    if (_adapterFactories.containsKey(entityType)) {
      final factory = _adapterFactories[entityType]!;
      return factory.create(entity);
    }

    // If no specific adapter is registered, use the non-generic base adapter
    return BaseDefaultUXAdapter(entity);
  }

  /// Get an adapter for an entity, using the appropriate factory
  UXAdapter getAdapter<T extends Entity<T>>(
    T entity, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    final entityType = entity.runtimeType;

    // Check for a disclosure-level specific adapter
    if (_disclosureLevelAdapters.containsKey(entityType)) {
      final levelAdapters = _disclosureLevelAdapters[entityType]!;

      // Find the highest appropriate disclosure level
      DisclosureLevel? selectedLevel;
      for (final level in levelAdapters.keys) {
        if (level.index <= disclosureLevel.index &&
            (selectedLevel == null || level.index > selectedLevel.index)) {
          selectedLevel = level;
        }
      }

      // If we found a suitable adapter, use it
      if (selectedLevel != null) {
        final factory = levelAdapters[selectedLevel]!;
        return factory.create(entity);
      }
    }

    // Otherwise use the standard adapter
    if (_adapterFactories.containsKey(entityType)) {
      final factory = _adapterFactories[entityType]!;
      return factory.create(entity);
    }

    // If no specific adapter is registered, use the non-generic base adapter
    return BaseDefaultUXAdapter(entity);
  }

  /// Check if a specific adapter is registered for an entity type
  bool hasAdapter<T extends Entity<T>>() {
    return _adapterFactories.containsKey(T) ||
        _disclosureLevelAdapters.containsKey(T);
  }

  /// Clear all registered adapters
  void clear() {
    _adapterFactories.clear();
    _disclosureLevelAdapters.clear();
    _conceptAdapterFactories.clear();
    _conceptDisclosureLevelAdapters.clear();
  }
}

/// A progressive adapter that supports disclosure levels
abstract class ProgressiveUXAdapter<T extends Entity<T>> implements UXAdapter {
  /// The entity being adapted
  @override
  final T entity;

  /// Constructor
  ProgressiveUXAdapter(this.entity);

  /// Build a form with fields filtered by disclosure level
  @override
  Widget buildForm(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    final filteredFields = filterFieldsByDisclosure(
      getFieldDescriptors(disclosureLevel: disclosureLevel),
      disclosureLevel,
    );

    return DefaultFormBuilder<T>(
      entity: entity,
      fields: filteredFields,
      initialData: getInitialFormData(),
      disclosureLevel: disclosureLevel,
      onLevelChanged: (newLevel) {
        return buildForm(context, disclosureLevel: newLevel);
      },
    );
  }

  /// Build a detailed view with progressive disclosure
  @override
  Widget buildDetailView(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    // Default implementation - can be overridden
    final filteredFields = filterFieldsByDisclosure(
      getFieldDescriptors(disclosureLevel: disclosureLevel),
      disclosureLevel,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entity.toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            ...filteredFields.map((field) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        field.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatFieldValue(
                          entity.getAttribute(field.fieldName),
                          field.fieldType,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Build a visualization (default implementation)
  @override
  Widget buildVisualization(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    // Default implementation - can be overridden
    return Card(
      child: ListTile(
        title: Text(entity.toString()),
        subtitle: Text(entity.concept.code),
      ),
    );
  }

  /// Format a field value for display
  String _formatFieldValue(Object? value, UXFieldType fieldType) {
    if (value == null) return '';

    switch (fieldType) {
      case UXFieldType.date:
        if (value is DateTime) {
          return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
        }
        return value.toString();
      case UXFieldType.checkbox:
        return value is bool && value ? 'Yes' : 'No';
      default:
        return value.toString();
    }
  }

  /// Filters fields based on the current disclosure level
  List<UXFieldDescriptor> filterFieldsByDisclosure(
    List<UXFieldDescriptor> allFields,
    DisclosureLevel level,
  ) {
    return allFields.where((field) {
      // Get the minimum level required to show this field
      final minLevel = field.metadata['disclosureLevel'] as DisclosureLevel? ??
          DisclosureLevel.basic;

      // Show the field if the current level is at least the minimum required level
      return level.isAtLeast(minLevel);
    }).toList();
  }

  /// Create a disclosure control that allows users to see more/less
  Widget buildDisclosureControl(
    BuildContext context,
    DisclosureLevel currentLevel,
    Function(DisclosureLevel) onLevelChanged,
  ) {
    // Get previous and next levels without using extension methods
    DisclosureLevel? previousLevel;
    DisclosureLevel? nextLevel;

    switch (currentLevel) {
      case DisclosureLevel.minimal:
        previousLevel = null;
        nextLevel = DisclosureLevel.basic;
        break;
      case DisclosureLevel.basic:
        previousLevel = DisclosureLevel.minimal;
        nextLevel = DisclosureLevel.intermediate;
        break;
      case DisclosureLevel.intermediate:
        previousLevel = DisclosureLevel.basic;
        nextLevel = DisclosureLevel.advanced;
        break;
      case DisclosureLevel.advanced:
        previousLevel = DisclosureLevel.intermediate;
        nextLevel = DisclosureLevel.complete;
        break;
      case DisclosureLevel.complete:
        previousLevel = DisclosureLevel.advanced;
        nextLevel = null;
        break;
      case DisclosureLevel.standard:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DisclosureLevel.detailed:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DisclosureLevel.debug:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (previousLevel != null)
          TextButton.icon(
            icon: const Icon(Icons.remove_circle_outline),
            label: const Text('Show less'),
            onPressed: () => onLevelChanged(previousLevel!),
          ),
        if (nextLevel != null)
          TextButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Show more'),
            onPressed: () => onLevelChanged(nextLevel!),
          ),
      ],
    );
  }

  @override
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    // Default implementation - override in subclasses
    return true;
  }

  @override
  Map<String, dynamic> getMetadata() => {
        'entityType': entity.concept.code,
        'entityId': entity.id?.toString(),
      };
}

/// Default adapter implementation for any entity type
class DefaultUXAdapter<T extends Entity<T>> extends ProgressiveUXAdapter<T> {
  /// Constructor
  DefaultUXAdapter(T entity) : super(entity);

  @override
  List<UXFieldDescriptor> getFieldDescriptors({
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    // Create field descriptors from entity attributes
    final result = <UXFieldDescriptor>[];

    for (final attribute in entity.concept.attributes) {
      // Determine field type
      final fieldType = _determineFieldType(attribute.type?.code ?? 'String');

      // Create disclosure level based on attribute properties
      var attrLevel = DisclosureLevel.basic;
      if (attribute.code.startsWith('__')) {
        attrLevel = DisclosureLevel.complete;
      } else if (attribute.code.startsWith('_')) {
        attrLevel = DisclosureLevel.advanced;
      } else if (!attribute.required) {
        attrLevel = DisclosureLevel.intermediate;
      } else {
        attrLevel = DisclosureLevel.minimal;
      }

      // Only add if appropriate for this disclosure level
      if (attrLevel.index <= disclosureLevel.index) {
        result.add(
          UXFieldDescriptor(
            fieldName: attribute.code,
            displayName: _formatDisplayName(attribute.code),
            fieldType: fieldType,
            required: attribute.required,
            disclosureLevel: attrLevel,
          ),
        );
      }
    }

    return result;
  }

  @override
  Map<String, dynamic> getInitialFormData() {
    // Create a map of attribute values
    final result = <String, dynamic>{};

    for (final attribute in entity.concept.attributes) {
      final value = entity.getAttribute(attribute.code);
      if (value != null) {
        result[attribute.code] = value;
      }
    }

    return result;
  }

  @override
  Widget buildListItem(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.minimal,
  }) {
    // Default implementation of a list item
    return Card(
      child: ListTile(
        title: Text(entity.toString()),
        subtitle: disclosureLevel.index >= DisclosureLevel.basic.index
            ? Text(entity.concept.code)
            : null,
      ),
    );
  }

  /// Determine field type from attribute type
  UXFieldType _determineFieldType(String typeCode) {
    switch (typeCode.toLowerCase()) {
      case 'string':
        return UXFieldType.text;
      case 'text':
      case 'longtext':
        return UXFieldType.longText;
      case 'int':
      case 'double':
      case 'num':
      case 'number':
        return UXFieldType.number;
      case 'datetime':
      case 'date':
        return UXFieldType.date;
      case 'boolean':
      case 'bool':
        return UXFieldType.checkbox;
      default:
        return UXFieldType.text;
    }
  }

  /// Format a field name for display
  String _formatDisplayName(String code) {
    // Add spaces before capital letters and capitalize first letter
    final spaced = code
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim();

    return spaced.substring(0, 1).toUpperCase() + spaced.substring(1);
  }
}

/// Non-generic base adapter that can be used to avoid type parameter inference issues
class BaseDefaultUXAdapter implements UXAdapter {
  /// The entity being adapted
  @override
  final Entity entity;

  /// Constructor
  BaseDefaultUXAdapter(this.entity);

  @override
  Widget buildForm(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    // Basic form builder implementation
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entity: ${entity.concept.code}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            const Text('This entity does not have a specialized adapter.'),
            const SizedBox(height: 8),
            // Add basic attributes display
            ...entity.concept.attributes
                .where((attr) => !attr.code.startsWith('_'))
                .map(
                  (attr) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            attr.code,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatValue(entity.getAttribute(attr.code)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildListItem(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.minimal,
  }) {
    return Card(
      child: ListTile(
        title: Text(entity.concept.code),
        subtitle: Text('ID: ${entity.id}'),
      ),
    );
  }

  @override
  Widget buildDetailView(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    return buildForm(context, disclosureLevel: disclosureLevel);
  }

  @override
  Widget buildVisualization(
    BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    return Card(child: ListTile(title: Text(entity.concept.code)));
  }

  @override
  List<UXFieldDescriptor> getFieldDescriptors({
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    // Create basic field descriptors from entity attributes
    return entity.concept.attributes
        .where(
          (attr) => !attr.code.startsWith('_'),
        ) // Filter out private attributes
        .map(
          (attr) => UXFieldDescriptor(
            fieldName: attr.code,
            displayName: attr.code,
            fieldType: _mapTypeToFieldType(attr.type?.code),
            required: attr.required,
          ),
        )
        .toList();
  }

  /// Map attribute type code to UXFieldType
  UXFieldType _mapTypeToFieldType(String? typeCode) {
    if (typeCode == null) return UXFieldType.text;

    switch (typeCode.toLowerCase()) {
      case 'number':
      case 'integer':
      case 'int':
      case 'double':
      case 'float':
        return UXFieldType.number;
      case 'boolean':
      case 'bool':
        return UXFieldType.checkbox;
      case 'datetime':
      case 'date':
        return UXFieldType.date;
      case 'text':
      case 'longtext':
        return UXFieldType.longText;
      default:
        return UXFieldType.text;
    }
  }

  @override
  Map<String, dynamic> getInitialFormData() {
    // Create a map of all attribute values
    final data = <String, dynamic>{};
    for (final attr in entity.concept.attributes) {
      final value = entity.getAttribute(attr.code);
      if (value != null) {
        data[attr.code] = value;
      }
    }
    return data;
  }

  /// Format a value for display
  String _formatValue(Object? value) {
    if (value == null) return '';
    if (value is DateTime) {
      return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
    }
    return value.toString();
  }

  @override
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    // Basic implementation - update entity with form data
    formData.forEach((key, value) {
      entity.setAttribute(key, value);
    });
    return true;
  }

  @override
  Map<String, dynamic> getMetadata() => {
        'entityType': entity.concept.code,
        'entityId': entity.id?.toString(),
      };

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Handle any method calls that are not explicitly implemented
    return null;
  }
}
