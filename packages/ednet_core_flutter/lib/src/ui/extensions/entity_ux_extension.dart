part of ednet_core_flutter;

/// Provides extension methods for UX adaptation
extension EntityUXExtension<T extends Entity<T>> on T {
  /// Get a UX adapter for this entity
  UXAdapter getUXAdapter({DisclosureLevel? disclosureLevel}) {
    return UXAdapterRegistry().getAdapter<T>(
      this,
      disclosureLevel: disclosureLevel ?? DisclosureLevel.basic,
    );
  }

  /// Build a form for this entity
  Widget buildForm(BuildContext context, {DisclosureLevel? disclosureLevel}) {
    return getUXAdapter(disclosureLevel: disclosureLevel).buildForm(
      context,
      disclosureLevel: disclosureLevel ?? DisclosureLevel.basic,
    );
  }

  /// Build a list item representation of this entity
  Widget buildListItem(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    return getUXAdapter(disclosureLevel: disclosureLevel).buildListItem(
      context,
      disclosureLevel: disclosureLevel ?? DisclosureLevel.minimal,
    );
  }

  /// Build a detailed view of this entity
  Widget buildDetailView(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    return getUXAdapter(disclosureLevel: disclosureLevel).buildDetailView(
      context,
      disclosureLevel: disclosureLevel ?? DisclosureLevel.standard,
    );
  }

  /// Build a visualization of this entity
  Widget buildVisualization(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    return getUXAdapter(disclosureLevel: disclosureLevel).buildVisualization(
      context,
      disclosureLevel: disclosureLevel ?? DisclosureLevel.standard,
    );
  }
}

/// Helper method to get adapter for an entity
UXAdapter getUXAdapter<T extends Entity<T>>(
  T entity, {
  DisclosureLevel? disclosureLevel,
}) {
  return UXAdapterRegistry().getAdapter<T>(
    entity,
    disclosureLevel: disclosureLevel ?? DisclosureLevel.basic,
  );
}

/// Extension on ShellApp for entity UX features
extension ShellAppEntityExtension on ShellApp {
  /// Get application version
  String get appVersion => '1.0.0';

  /// Show an entity details dialog
  void showEntityDetails(BuildContext context, Entity entity,
      {DisclosureLevel? disclosureLevel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Entity Details: ${entity.concept.code}'),
          content: SizedBox(
            width: 600,
            height: 400,
            child: SingleChildScrollView(
              child: buildEntityDetailsList(
                context,
                entity,
                disclosureLevel: disclosureLevel,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Build an entity details list
  Widget buildEntityDetailsList(BuildContext context, Entity entity,
      {DisclosureLevel? disclosureLevel}) {
    final effectiveDisclosureLevel = disclosureLevel ?? currentDisclosureLevel;
    final visibleAttributes = getVisibleAttributes(
      entity.concept,
      effectiveDisclosureLevel,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Entity information
        const Text(
          'Entity Information',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Concept', entity.concept.code),
        _buildInfoRow('ID', entity.oid.toString()),
        const Divider(),

        // Attributes
        const Text(
          'Attributes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        for (final attribute in visibleAttributes)
          _buildAttributeRow(entity, attribute),
      ],
    );
  }

  /// Get visible attributes based on disclosure level
  List<Attribute> getVisibleAttributes(Concept concept, DisclosureLevel level) {
    final allAttributes = concept.attributes.whereType<Attribute>().toList();

    switch (level) {
      case DisclosureLevel.minimal:
        // Show only identity attributes
        return allAttributes
            .where((attr) => attr.identifier || attr.required)
            .toList();
      case DisclosureLevel.basic:
        // Show required and important attributes
        return allAttributes.where((attr) => attr.essential).toList();
      case DisclosureLevel.standard:
        // Show all but derived attributes
        return allAttributes.where((attr) => !attr.derive).toList();
      case DisclosureLevel.intermediate:
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        // Show all attributes
        return allAttributes;
    }
  }

  /// Build an attribute row
  Widget _buildAttributeRow(Entity entity, Attribute attribute) {
    dynamic value;
    try {
      value = entity.getAttribute(attribute.code);
    } catch (e) {
      value = 'Error: $e';
    }

    final displayValue = value?.toString() ?? 'null';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              attribute.code,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(displayValue),
          ),
        ],
      ),
    );
  }

  /// Build an info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Find a concept by its code
  Concept? findConcept(String conceptCode) {
    return _findConcept(conceptCode);
  }
}
