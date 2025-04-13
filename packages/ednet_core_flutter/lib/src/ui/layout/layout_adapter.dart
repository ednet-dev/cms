part of ednet_core_flutter;

/// Base class for layout adapters that convert domain entities to UI widgets
class LayoutAdapter<T extends Entity<T>> {
  /// Build a form for creating or editing an entity
  Widget buildForm(BuildContext context, T entity,
      {DisclosureLevel? disclosureLevel}) {
    // Default implementation returns a basic form
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Form for ${entity.code}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
              'No custom form implementation provided for ${entity.concept.code}'),
        ],
      ),
    );
  }

  /// Build a list item representation of an entity
  Widget buildListItem(BuildContext context, T entity,
      {DisclosureLevel? disclosureLevel}) {
    // Default implementation returns a basic list item
    return ListTile(
      title: Text(entity.code),
      subtitle: Text(entity.concept.code),
    );
  }

  /// Build a detailed view of an entity
  Widget buildDetailView(BuildContext context, T entity,
      {DisclosureLevel? disclosureLevel}) {
    // Default implementation returns a basic detail view
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entity.code,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Type: ${entity.concept.code}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(),
          // Display basic properties
          const Text('Default detail view - customize in adapter'),
        ],
      ),
    );
  }

  /// Build a visualization of an entity or relationships
  Widget buildVisualization(BuildContext context, T entity,
      {DisclosureLevel? disclosureLevel}) {
    // Default implementation returns a basic visualization
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text('Visualization for ${entity.concept.code}: ${entity.code}'),
      ),
    );
  }
}

/// Registry for managing layout adapters
class LayoutAdapterRegistry {
  final Map<Type, LayoutAdapter> _adapters = {};
  final Map<Type, Map<DisclosureLevel, LayoutAdapter>> _disclosureAdapters = {};

  /// Register a layout adapter for a specific entity type
  void register<T extends Entity<T>>(LayoutAdapter<T> adapter) {
    _adapters[T] = adapter;
  }

  /// Register a layout adapter for a specific type
  void registerType(Type type, LayoutAdapter adapter) {
    _adapters[type] = adapter;
  }

  /// Register a disclosure level-specific adapter
  void registerWithDisclosure<T extends Entity<T>>(
    LayoutAdapter<T> adapter,
    DisclosureLevel level,
  ) {
    _disclosureAdapters.putIfAbsent(T, () => {});
    _disclosureAdapters[T]![level] = adapter;
  }

  /// Get an adapter for an entity type
  LayoutAdapter<T>? getAdapter<T extends Entity<T>>(
      {DisclosureLevel? disclosureLevel}) {
    if (disclosureLevel != null && _disclosureAdapters.containsKey(T)) {
      return _disclosureAdapters[T]![disclosureLevel] as LayoutAdapter<T>?;
    }
    return _adapters[T] as LayoutAdapter<T>?;
  }
}

/// Default layout adapter for Domain entities
class DomainLayoutAdapter extends LayoutAdapter<Domain> {
  @override
  Widget buildForm(BuildContext context, Domain entity,
      {DisclosureLevel? disclosureLevel}) {
    // Implement form building for Domain
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: entity.code,
            decoration: const InputDecoration(labelText: 'Domain Code'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: entity.description,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildListItem(BuildContext context, Domain entity,
      {DisclosureLevel? disclosureLevel}) {
    return ListTile(
      title: Text(entity.code),
      subtitle: Text(entity.description),
      trailing: Text('Models: ${entity.models.length}'),
    );
  }

  @override
  Widget buildDetailView(BuildContext context, Domain entity,
      {DisclosureLevel? disclosureLevel}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entity.code,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            entity.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(),
          Text(
            'Models (${entity.models.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: entity.models.length,
              itemBuilder: (context, index) {
                final model = entity.models.elementAt(index);
                return ListTile(
                  title: Text(model.code),
                  subtitle: Text('Concepts: ${model.concepts.length}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Default layout adapter for Model entities
class ModelLayoutAdapter extends LayoutAdapter<Model> {
  @override
  Widget buildListItem(BuildContext context, Model entity,
      {DisclosureLevel? disclosureLevel}) {
    return ListTile(
      title: Text(entity.code),
      subtitle: Text(entity.description ?? ''),
      trailing: Text('Concepts: ${entity.concepts.length}'),
    );
  }
}

/// Default layout adapter for Concept entities
class ConceptLayoutAdapter extends LayoutAdapter<Concept> {
  @override
  Widget buildListItem(BuildContext context, Concept entity,
      {DisclosureLevel? disclosureLevel}) {
    return ListTile(
      title: Text(entity.code),
      subtitle: Text(entity.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (entity.entry) const Chip(label: Text('Entry')),
          if (entity.abstract) const Chip(label: Text('Abstract')),
        ],
      ),
    );
  }
}
