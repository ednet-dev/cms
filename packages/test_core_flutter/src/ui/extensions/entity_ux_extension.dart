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
