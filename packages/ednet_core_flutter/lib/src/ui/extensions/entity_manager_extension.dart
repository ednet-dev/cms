part of ednet_core_flutter;

/// Extension for ShellApp providing entity management functionality
extension EntityManagerExtension on ShellApp {
  /// Navigate to entity manager view for a concept
  void showEntityManager(
    BuildContext context,
    String conceptCode, {
    String? title,
    EntityViewMode initialViewMode = EntityViewMode.list,
    bool allowViewModeChange = true,
    bool showCreateFab = true,
    DisclosureLevel? disclosureLevel,
  }) {
    // Check if the EntityManagerView and entity editing features are available
    if (!hasFeature('entity_editing') || !hasFeature('entity_creation')) {
      debugPrint('Entity editing or creation features are not enabled');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entity management is not enabled')),
      );
      return;
    }

    // Navigate to EntityManagerView
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EntityManagerView(
          shellApp: this,
          conceptCode: conceptCode,
          appBarTitle: title ?? 'Manage $conceptCode',
          initialViewMode: initialViewMode,
          allowViewModeChange: allowViewModeChange,
          showCreateFab: showCreateFab,
          disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
        ),
      ),
    );
  }

  /// Navigate to entity editor view for creating a new entity
  Future<bool?> showEntityCreator(
    BuildContext context,
    String conceptCode, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Verify concept exists
    final concept = findConcept(conceptCode);
    if (concept == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Concept "$conceptCode" not found')),
      );
      return Future.value(false);
    }

    // Create a new entity from the concept
    final entity = EntityFactory.createEntityFromData(concept, {});

    // Show editor in a scaffold
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Create $conceptCode'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: GenericEntityForm(
              entity: entity,
              shellApp: this,
              disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
              isEditMode: false,
            ),
          ),
        ),
      ),
    );
  }

  /// Navigate to entity editor view for editing an existing entity
  Future<bool?> showEntityEditor(
    BuildContext context,
    String conceptCode,
    Map<String, dynamic> entityData, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Verify concept exists
    final concept = findConcept(conceptCode);
    if (concept == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Concept "$conceptCode" not found')),
      );
      return Future.value(false);
    }

    // Create entity from data
    final entity = EntityFactory.createEntityFromData(concept, entityData);

    // Show editor in a scaffold
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Edit $conceptCode'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: GenericEntityForm(
              entity: entity,
              shellApp: this,
              initialData: entityData,
              disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
              isEditMode: true,
            ),
          ),
        ),
      ),
    );
  }
}
