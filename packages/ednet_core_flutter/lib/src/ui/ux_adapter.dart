part of ednet_core_flutter;

/// Interface for adapting domain entities to UI representations
/// @deprecated Use LayoutAdapter instead
@deprecated
abstract class UXAdapter {
  /// Build a form for creating or editing an entity
  Widget buildForm(BuildContext context, {DisclosureLevel? disclosureLevel});

  /// Build a list item representation of an entity
  Widget buildListItem(BuildContext context,
      {DisclosureLevel? disclosureLevel});

  /// Build a detailed view of an entity
  Widget buildDetailView(BuildContext context,
      {DisclosureLevel? disclosureLevel});

  /// Build a visualization of an entity or relationships
  Widget buildVisualization(BuildContext context,
      {DisclosureLevel? disclosureLevel});

  /// Validate the current form state
  bool validateForm();

  /// Submit form data and return success or failure
  Future<bool> submitForm(Map<String, dynamic> formData);

  /// Get the entity code
  String getEntityCode();

  /// Get the entity concept code
  String getConceptCode();

  /// Get list of entity attributes to display
  List<String> getAttributesToDisplay({DisclosureLevel? disclosureLevel});

  /// Get list of entity relationships to display
  List<String> getRelationshipsToDisplay({DisclosureLevel? disclosureLevel});

  /// Get icon to represent this entity
  IconData getEntityIcon();

  /// Get color to represent this entity
  Color getEntityColor(BuildContext context);

  /// Get display name for the entity (may differ from code)
  String getDisplayName();

  /// Get description of the entity
  String getDescription();

  /// Get metadata about the entity (createdAt, updatedAt, etc)
  Map<String, dynamic> getMetadata();
}

/// Factory for creating UX adapters for specific entity types
/// @deprecated Use LayoutAdapter instead
@deprecated
abstract class UXAdapterFactory<T extends Entity<T>> {
  /// Create a UX adapter for a given entity
  UXAdapter create(T entity);
}

/// Registry of UX adapters for different entity types
/// @deprecated Use LayoutAdapter instead
@deprecated
class UXAdapterRegistry {
  static final UXAdapterRegistry _instance = UXAdapterRegistry._internal();

  // Private constructor for singleton
  UXAdapterRegistry._internal();

  // Factory constructor to return the singleton instance
  factory UXAdapterRegistry() => _instance;

  // Map of entity type to UX adapter factory
  final Map<Type, UXAdapterFactory> _adapterFactories = {};

  // Map of entity type to disclosure level-specific UX adapter factories
  final Map<Type, Map<DisclosureLevel, UXAdapterFactory>>
      _disclosureAdapterFactories = {};

  // Map of concept code to UX adapter factory
  final Map<String, UXAdapterFactory> _conceptAdapterFactories = {};

  // Map of concept code to disclosure level-specific UX adapter factories
  final Map<String, Map<DisclosureLevel, UXAdapterFactory>>
      _disclosureConceptAdapterFactories = {};

  /// Register a UX adapter factory for an entity type
  void register<T extends Entity<T>>(UXAdapterFactory<T> factory) {
    _adapterFactories[T] = factory;
  }

  /// Register a dynamic UX adapter factory for an entity type
  void registerDynamic(Type entityType, UXAdapterFactory factory) {
    _adapterFactories[entityType] = factory;
  }

  /// Register a disclosure level-specific UX adapter factory for an entity type
  void registerWithDisclosure<T extends Entity<T>>(
    UXAdapterFactory<T> factory,
    DisclosureLevel level,
  ) {
    _disclosureAdapterFactories.putIfAbsent(T, () => {});
    _disclosureAdapterFactories[T]![level] = factory;
  }

  /// Register a UX adapter factory for a concept code
  void registerByConceptCode(
    String conceptCode,
    UXAdapterFactory factory, {
    DisclosureLevel? level,
  }) {
    if (level != null) {
      _disclosureConceptAdapterFactories.putIfAbsent(conceptCode, () => {});
      _disclosureConceptAdapterFactories[conceptCode]![level] = factory;
    } else {
      _conceptAdapterFactories[conceptCode] = factory;
    }
  }

  /// Get a UX adapter for an entity based on its concept code
  UXAdapter getAdapterByConceptCode(
    Entity entity, {
    DisclosureLevel? disclosureLevel,
  }) {
    final conceptCode = entity.concept.code;
    UXAdapterFactory? factory;

    // Check for disclosure level-specific factory for this concept code
    if (disclosureLevel != null &&
        _disclosureConceptAdapterFactories.containsKey(conceptCode) &&
        _disclosureConceptAdapterFactories[conceptCode]!
            .containsKey(disclosureLevel)) {
      factory =
          _disclosureConceptAdapterFactories[conceptCode]![disclosureLevel];
    }

    // If not found, try the default factory for this concept code
    if (factory == null && _conceptAdapterFactories.containsKey(conceptCode)) {
      factory = _conceptAdapterFactories[conceptCode];
    }

    // If we found a factory, use it
    if (factory != null) {
      return factory.create(entity);
    }

    // Try each entry in the registry until we find a matching type
    for (final type in _adapterFactories.keys) {
      if (entity.runtimeType == type) {
        factory = _adapterFactories[type];
        break;
      }
    }

    // If found a matching type, use it
    if (factory != null) {
      return factory.create(entity);
    }

    // Try to find a factory by matching the concept code pattern
    for (final code in _conceptAdapterFactories.keys) {
      if (conceptCode.contains(code)) {
        factory = _conceptAdapterFactories[code];
        break;
      }
    }

    // If we found a matching pattern, use it
    if (factory != null) {
      return factory.create(entity);
    }

    // If we still haven't found a factory, use the default adapter
    return BaseDefaultUXAdapter(entity);
  }

  /// Get a UX adapter for an entity by its type
  UXAdapter getAdapter<T extends Entity<T>>(
    T entity, {
    DisclosureLevel? disclosureLevel,
  }) {
    // First try disclosure level-specific factory
    if (disclosureLevel != null &&
        _disclosureAdapterFactories.containsKey(T) &&
        _disclosureAdapterFactories[T]!.containsKey(disclosureLevel)) {
      return _disclosureAdapterFactories[T]![disclosureLevel]!.create(entity);
    }

    // Then try the basic factory
    if (_adapterFactories.containsKey(T)) {
      return _adapterFactories[T]!.create(entity);
    }

    // Try by concept code
    return getAdapterByConceptCode(
      entity,
      disclosureLevel: disclosureLevel,
    );
  }

  /// Check if there is a registered adapter for a given type
  bool hasAdapterFor<T extends Entity<T>>() {
    return _adapterFactories.containsKey(T);
  }

  /// Check if there is a registered adapter for a given concept code
  bool hasAdapterForConceptCode(String conceptCode) {
    return _conceptAdapterFactories.containsKey(conceptCode);
  }

  /// Check if there is a registered disclosure level-specific adapter for a given type
  bool hasDisclosureAdapterFor<T extends Entity<T>>(DisclosureLevel level) {
    return _disclosureAdapterFactories.containsKey(T) &&
        _disclosureAdapterFactories[T]!.containsKey(level);
  }

  /// Check if there is a registered disclosure level-specific adapter for a given concept code
  bool hasDisclosureAdapterForConceptCode(
      String conceptCode, DisclosureLevel level) {
    return _disclosureConceptAdapterFactories.containsKey(conceptCode) &&
        _disclosureConceptAdapterFactories[conceptCode]!.containsKey(level);
  }
}

/// Base class for implementing progressive disclosure in UX adapters
/// @deprecated Use LayoutAdapter instead
@deprecated
abstract class ProgressiveUXAdapter<T extends Entity<T>> implements UXAdapter {
  /// The entity being adapted
  final T entity;

  /// Constructor
  ProgressiveUXAdapter(this.entity);

  @override
  List<String> getAttributesToDisplay({DisclosureLevel? disclosureLevel}) {
    final level = disclosureLevel ?? DisclosureLevel.standard;
    final attributes = <String>[];

    // Get all attributes
    for (final attr in entity.concept.attributes.whereType<Attribute>()) {
      var include = false;

      // Apply progressive disclosure logic
      switch (level) {
        case DisclosureLevel.minimal:
          // Only include the most essential attributes for minimal display
          include = attr.identifier || attr.essential;
          break;

        case DisclosureLevel.basic:
          // Basic includes identifiers, essential attributes, and required attributes
          include = attr.identifier || attr.essential || attr.required;
          break;

        case DisclosureLevel.standard:
          // Standard includes most attributes except sensitivity or derived
          include = !attr.sensitive && !attr.derive;
          break;

        case DisclosureLevel.intermediate:
          // Intermediate includes everything except sensitive
          include = !attr.sensitive;
          break;

        case DisclosureLevel.advanced:
        case DisclosureLevel.detailed:
        case DisclosureLevel.complete:
          // Advanced, detailed and complete include everything
          include = true;
          break;

        case DisclosureLevel.debug:
          // Debug includes absolutely everything plus adds more
          include = true;
          break;
      }

      if (include) {
        attributes.add(attr.code);
      }
    }

    return attributes;
  }

  @override
  List<String> getRelationshipsToDisplay({DisclosureLevel? disclosureLevel}) {
    final level = disclosureLevel ?? DisclosureLevel.standard;
    final relationships = <String>[];

    // Process parent relationships
    for (final parent in entity.concept.parents.whereType<Parent>()) {
      var include = false;

      // Apply progressive disclosure logic
      switch (level) {
        case DisclosureLevel.minimal:
          // Only show internal/identifying parents in minimal view
          include = parent.internal || parent.identifier;
          break;

        case DisclosureLevel.basic:
          // Basic adds required parents
          include = parent.internal || parent.identifier || parent.required;
          break;

        case DisclosureLevel.standard:
          // Standard shows most non-sensitive relationships
          include = !parent.sensitive;
          break;

        case DisclosureLevel.intermediate:
        case DisclosureLevel.advanced:
        case DisclosureLevel.detailed:
        case DisclosureLevel.complete:
          // More detailed levels show all relationships
          include = true;
          break;

        case DisclosureLevel.debug:
          // Debug includes everything
          include = true;
          break;
      }

      if (include) {
        relationships.add(parent.code);
      }
    }

    // Process child relationships
    for (final child in entity.concept.children.whereType<Child>()) {
      var include = false;

      // Apply progressive disclosure logic
      switch (level) {
        case DisclosureLevel.minimal:
          // Only show internal children in minimal view
          include = child.internal;
          break;

        case DisclosureLevel.basic:
          // Basic shows internal and a few more important children
          include = child.internal || child.essential;
          break;

        case DisclosureLevel.standard:
          // Standard shows non-sensitive children
          include = !child.sensitive;
          break;

        case DisclosureLevel.intermediate:
        case DisclosureLevel.advanced:
        case DisclosureLevel.detailed:
        case DisclosureLevel.complete:
          // More detailed levels show all children
          include = true;
          break;

        case DisclosureLevel.debug:
          // Debug includes everything
          include = true;
          break;
      }

      if (include) {
        relationships.add(child.code);
      }
    }

    return relationships;
  }

  @override
  String getEntityCode() {
    return entity.code;
  }

  @override
  String getConceptCode() {
    return entity.concept.code;
  }

  @override
  IconData getEntityIcon() {
    // Default icon based on entity type
    if (entity is Domain) {
      return Icons.cloud;
    } else if (entity is Model) {
      return Icons.data_object;
    } else if (entity is Concept) {
      return Icons.schema;
    } else if (entity is Property) {
      if (entity is Parent || entity is Child) {
        return Icons.link;
      } else {
        return Icons.text_fields;
      }
    }
    // Default icon
    return Icons.widgets;
  }

  @override
  Color getEntityColor(BuildContext context) {
    // Default colors based on entity type
    if (entity is Domain) {
      return Colors.blue;
    } else if (entity is Model) {
      return Colors.green;
    } else if (entity is Concept) {
      return Colors.orange;
    } else if (entity is Property) {
      if (entity is Parent || entity is Child) {
        return Colors.purple;
      } else {
        return Colors.red;
      }
    }
    // Default color
    return Colors.grey;
  }

  @override
  String getDisplayName() {
    // Use the label if available, otherwise use code
    if (entity is Concept) {
      final concept = entity as Concept;
      return concept.label ?? concept.code;
    }
    return entity.code;
  }

  @override
  String getDescription() {
    // Try to get description from the entity
    try {
      // Using dynamic access to support various entity types
      final dynamic entityDynamic = entity;
      if (entityDynamic.description != null) {
        return entityDynamic.description;
      }
    } catch (_) {
      // Ignore if the entity doesn't have a description
    }
    return '';
  }

  @override
  Map<String, dynamic> getMetadata() {
    final metadata = <String, dynamic>{};

    // Basic entity metadata
    metadata['oid'] = entity.oid.toString();
    if (entity.whenAdded != null) {
      metadata['whenAdded'] = entity.whenAdded;
    }
    if (entity.whenSet != null) {
      metadata['whenSet'] = entity.whenSet;
    }

    return metadata;
  }
}

/// Default implementation of UXAdapter
/// @deprecated Use LayoutAdapter instead
@deprecated
class DefaultUXAdapter<T extends Entity<T>> extends ProgressiveUXAdapter<T> {
  /// Constructor
  DefaultUXAdapter(T entity) : super(entity);

  @override
  Widget buildForm(BuildContext context, {DisclosureLevel? disclosureLevel}) {
    final attrs = getAttributesToDisplay(disclosureLevel: disclosureLevel);
    final relationships =
        getRelationshipsToDisplay(disclosureLevel: disclosureLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Form title
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            '${getDisplayName()} Form',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        // Attributes section
        if (attrs.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Attributes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...attrs.map((attr) => _buildFormField(context, attr)),
          const SizedBox(height: 16),
        ],

        // Relationships section
        if (relationships.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Relationships',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...relationships.map((rel) => _buildRelationshipField(context, rel)),
        ],
      ],
    );
  }

  Widget _buildFormField(BuildContext context, String attributeCode) {
    // Simplified form field for demo purposes
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: attributeCode,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildRelationshipField(
      BuildContext context, String relationshipCode) {
    // Simplified relationship field for demo purposes
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(relationshipCode),
        trailing: const Icon(Icons.arrow_forward),
        tileColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  @override
  Widget buildListItem(BuildContext context,
      {DisclosureLevel? disclosureLevel}) {
    return Card(
      child: ListTile(
        leading: Icon(getEntityIcon(), color: getEntityColor(context)),
        title: Text(getDisplayName()),
        subtitle: Text(getDescription()),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget buildDetailView(BuildContext context,
      {DisclosureLevel? disclosureLevel}) {
    final attrs = getAttributesToDisplay(disclosureLevel: disclosureLevel);
    final relationships =
        getRelationshipsToDisplay(disclosureLevel: disclosureLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon and title
        Row(
          children: [
            Icon(getEntityIcon(), color: getEntityColor(context), size: 32),
            const SizedBox(width: 16),
            Text(
              getDisplayName(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Description
        if (getDescription().isNotEmpty) ...[
          Text(
            getDescription(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
        ],

        // Attributes
        if (attrs.isNotEmpty) ...[
          Text(
            'Attributes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...attrs.map((attr) => _buildAttributeRow(context, attr)),
          const SizedBox(height: 16),
        ],

        // Relationships
        if (relationships.isNotEmpty) ...[
          Text(
            'Relationships',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...relationships.map((rel) => _buildRelationshipRow(context, rel)),
        ],
      ],
    );
  }

  Widget _buildAttributeRow(BuildContext context, String attributeCode) {
    final value = entity.getAttribute(attributeCode)?.toString() ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              attributeCode,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipRow(BuildContext context, String relationshipCode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              relationshipCode,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Icon(Icons.link, size: 16),
        ],
      ),
    );
  }

  @override
  Widget buildVisualization(BuildContext context,
      {DisclosureLevel? disclosureLevel}) {
    // Simple placeholder visualization
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getEntityIcon(),
            color: getEntityColor(context),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            getDisplayName(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (getDescription().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              getDescription(),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  @override
  bool validateForm() {
    // Default implementation just returns true
    return true;
  }

  @override
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    // Default implementation just returns success
    return true;
  }
}

/// Base implementation of UXAdapter for any entity
/// @deprecated Use LayoutAdapter instead
@deprecated
class BaseDefaultUXAdapter implements UXAdapter {
  /// The entity being adapted
  final Entity entity;

  /// Constructor
  BaseDefaultUXAdapter(this.entity);

  @override
  Widget buildForm(BuildContext context, {DisclosureLevel? disclosureLevel}) {
    // Simple placeholder form
    return Column(
      children: [
        Text('Form for ${entity.code}'),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            label: Text('Code'),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildListItem(BuildContext context,
      {DisclosureLevel? disclosureLevel}) {
    return ListTile(
      title: Text(entity.code),
      subtitle: Text('Entity of type ${entity.concept.code}'),
    );
  }

  @override
  Widget buildDetailView(BuildContext context,
      {DisclosureLevel? disclosureLevel}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entity.code,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Type: ${entity.concept.code}'),
            const SizedBox(height: 8),
            Text('OID: ${entity.oid}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildVisualization(BuildContext context,
      {DisclosureLevel? disclosureLevel}) {
    return Card(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: Text(entity.code),
        ),
      ),
    );
  }

  @override
  bool validateForm() {
    return true;
  }

  @override
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    return true;
  }

  @override
  String getEntityCode() {
    return entity.code;
  }

  @override
  String getConceptCode() {
    return entity.concept.code;
  }

  @override
  List<String> getAttributesToDisplay({DisclosureLevel? disclosureLevel}) {
    return entity.concept.attributes
        .whereType<Attribute>()
        .map((a) => a.code)
        .toList();
  }

  @override
  List<String> getRelationshipsToDisplay({DisclosureLevel? disclosureLevel}) {
    final relationships = <String>[];

    // Add parents
    relationships.addAll(
        entity.concept.parents.whereType<Parent>().map((p) => p.code).toList());

    // Add children
    relationships.addAll(
        entity.concept.children.whereType<Child>().map((c) => c.code).toList());

    return relationships;
  }

  @override
  IconData getEntityIcon() {
    return Icons.widgets;
  }

  @override
  Color getEntityColor(BuildContext context) {
    return Colors.grey;
  }

  @override
  String getDisplayName() {
    return entity.code;
  }

  @override
  String getDescription() {
    return '';
  }

  @override
  Map<String, dynamic> getMetadata() {
    return {
      'oid': entity.oid.toString(),
      'whenAdded': entity.whenAdded?.toString() ?? 'N/A',
      'whenSet': entity.whenSet?.toString() ?? 'N/A',
    };
  }
}
