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
}
