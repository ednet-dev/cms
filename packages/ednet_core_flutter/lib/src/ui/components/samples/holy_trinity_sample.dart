part of ednet_core_flutter;

/// Sample widget demonstrating the Holy Trinity architecture
///
/// This widget shows how to use the Holy Trinity architecture components
/// (layout strategy, theme strategy, and domain model) together to create
/// a semantic UI that adapts to different layout and theme strategies.
///
/// Part of the EDNet Shell Architecture's example components.
class HolyTrinitySample extends StatelessWidget {
  /// The disclosure level for this component
  final DisclosureLevel disclosureLevel;

  /// Create a new Holy Trinity sample with the given disclosure level
  const HolyTrinitySample({
    super.key,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  @override
  Widget build(BuildContext context) {
    // The layout adapter provides layout capabilities based on semantics
    final layoutAdapter = LayoutAdapter(context);

    return layoutAdapter.buildConceptContainer(
      context: context,
      conceptType: 'Sample',
      disclosureLevel: disclosureLevel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header using semantic styling from theme
          Text(
            'Holy Trinity Architecture Sample',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Progressive disclosure - only show explanation text at advanced levels
          if (disclosureLevel.index >= DisclosureLevel.intermediate.index)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'This sample demonstrates how to integrate layout, theme, and domain model strategies '
                'to create a cohesive UI that adapts to different contexts and disclosure levels.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

          // Domain section using different concepts from the domain model
          _buildDomainSection(context),
          const SizedBox(height: 16),

          // Model section
          _buildModelSection(context),
          const SizedBox(height: 16),

          // Concept section
          _buildConceptSection(context),
          const SizedBox(height: 16),

          // Entity section with attributes
          _buildEntitySection(context),
        ],
      ),
    );
  }

  /// Build a domain section with semantic styling
  Widget _buildDomainSection(BuildContext context) {
    final layoutAdapter = LayoutAdapter(context);

    return layoutAdapter.buildConceptContainer(
      context: context,
      conceptType: 'Domain',
      disclosureLevel: disclosureLevel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.domain,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Domain Section',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This is a domain container with semantic styling.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Build a model section with semantic styling
  Widget _buildModelSection(BuildContext context) {
    final layoutAdapter = LayoutAdapter(context);

    return layoutAdapter.buildConceptContainer(
      context: context,
      conceptType: 'Model',
      disclosureLevel: disclosureLevel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Model Section',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This is a model container with semantic styling.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Build a concept section with semantic styling
  Widget _buildConceptSection(BuildContext context) {
    final layoutAdapter = LayoutAdapter(context);

    return layoutAdapter.buildConceptContainer(
      context: context,
      conceptType: 'Concept',
      disclosureLevel: disclosureLevel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                'Concept Section',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This is a concept container with semantic styling.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Build an entity section with attributes
  Widget _buildEntitySection(BuildContext context) {
    final layoutAdapter = LayoutAdapter(context);

    return layoutAdapter.buildConceptContainer(
      context: context,
      conceptType: 'Entity',
      disclosureLevel: disclosureLevel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.ballot,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Entity Section',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Attributes list using semantic flow container
          layoutAdapter.buildFlowLayout(
            context: context,
            spacing: 8,
            runSpacing: 8,
            disclosureLevel: disclosureLevel,
            children: [
              _buildAttributeItem(context, 'ID', '12345'),
              _buildAttributeItem(context, 'Name', 'Sample Entity'),
              _buildAttributeItem(context, 'Type', 'Demo'),
              _buildAttributeItem(context, 'Created', '2023-04-01'),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper method to build an attribute item with semantic styling
  Widget _buildAttributeItem(BuildContext context, String name, String value) {
    final layoutAdapter = LayoutAdapter(context);

    return layoutAdapter.buildConceptContainer(
      context: context,
      conceptType: 'Attribute',
      disclosureLevel: disclosureLevel,
      fillWidth: false,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$name: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
