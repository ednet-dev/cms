// Code examples for utilizing features in ednet_core_flutter that are commonly underused

import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Example app showing proper integration of advanced ednet_core_flutter features
class FullFeaturedExampleApp extends StatefulWidget {
  final Domain domain;

  const FullFeaturedExampleApp({super.key, required this.domain});

  @override
  State<FullFeaturedExampleApp> createState() => _FullFeaturedExampleAppState();
}

class _FullFeaturedExampleAppState extends State<FullFeaturedExampleApp> {
  late ShellApp shellApp;
  ThemeMode currentThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    // Initialize shell with all advanced features enabled
    shellApp = _buildFullFeaturedShell();
  }

  /// Build a shell app with all advanced features enabled
  ShellApp _buildFullFeaturedShell() {
    return ShellApp(
      domain: widget.domain,
      configuration: ShellConfiguration(
        // Enable all the advanced features
        features: {
          // Core features
          'entity_editing',
          'entity_creation',

          // Advanced visualization
          'domain_model_diffing',
          'tree_navigation',

          // Meta-model features
          ShellConfiguration.metaModelEditingFeature,

          // UX features
          ShellConfiguration.genericEntityFormFeature,
          ShellConfiguration.themeSwitchingFeature,
          ShellConfiguration.enhancedEntityCollectionFeature,

          // Other advanced features
          'development_mode',
          'filtering',
          'deep_linking',
          'persistence',
        },
        // Use both sidebar modes (classic and tree)
        sidebarMode: SidebarMode.both,
        // Start with standard disclosure level
        defaultDisclosureLevel: DisclosureLevel.standard,
        // Enable theme toggle in AppBar
        showThemeToggleInAppBar: true,
        // Use Material 3
        useMaterial3: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDNet Full-Featured App',
      debugShowCheckedModeBanner: false,
      themeMode: currentThemeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Row(
          children: [
            // Example of using the tree sidebar
            if (shellApp.configuration.sidebarMode == SidebarMode.tree ||
                shellApp.configuration.sidebarMode == SidebarMode.both)
              TreeArtifactSidebar(
                shellApp: shellApp,
                onArtifactSelected: (path) {
                  // Navigate to the selected path
                  shellApp.navigateTo(path);
                },
              ),

            // Main content area using ShellAppRunner for core functionality
            Expanded(
              child: Stack(
                children: [
                  ShellAppRunner(
                    shellApp: shellApp,
                  ),

                  // Example of using the control panel features
                  if (shellApp.hasFeature('development_mode'))
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: DevelopmentModeControlPanel(
                        adapter: DevelopmentModeChannelAdapter(shellApp),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        // Example of using the floating action button for domain model diffing
        floatingActionButton: shellApp.hasFeature('domain_model_diffing')
            ? FloatingActionButton(
                onPressed: () => _showDomainModelDiffing(context),
                tooltip: 'Domain Model Diffing',
                child: const Icon(Icons.compare_arrows),
              )
            : null,
      ),
    );
  }

  /// Example of showing domain model diffing
  Future<void> _showDomainModelDiffing(BuildContext context) async {
    if (!shellApp.hasFeature('domain_model_diffing')) {
      return;
    }

    // Export the current domain model diff
    final diff = shellApp.exportDomainModelDiff(widget.domain.code);

    // Show a dialog with the diff
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Domain Model Diff'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: Text(diff),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Example of saving the diff to a file
              final success = await shellApp.saveDomainModelDiffToFile(
                widget.domain.code,
                'domain_model_diff.json',
              );

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diff saved successfully')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save Diff'),
          ),
        ],
      ),
    );
  }
}

/// Example of using the meta model editing features
class MetaModelEditorExample extends StatelessWidget {
  final ShellApp shellApp;

  const MetaModelEditorExample({super.key, required this.shellApp});

  @override
  Widget build(BuildContext context) {
    if (!shellApp.hasFeature(ShellConfiguration.metaModelEditingFeature)) {
      return const Center(
        child: Text('Meta Model Editing is not enabled'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: const Text('Meta Model Editor'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Button to add a new concept
                ElevatedButton.icon(
                  onPressed: () {
                    // Show dialog to add a new concept
                    // Implementation would use MetaModelManager
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Concept'),
                ),

                const SizedBox(height: 16),

                // Show existing concepts in a list
                Expanded(
                  child: _buildConceptList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build a list of existing concepts
  Widget _buildConceptList() {
    // Get all concepts from the domain
    final concepts =
        shellApp.domain.models.expand((model) => model.concepts).toList();

    return ListView.builder(
      itemCount: concepts.length,
      itemBuilder: (context, index) {
        final concept = concepts[index];
        return ListTile(
          title: Text(concept.code),
          subtitle: Text(concept.model.code),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit concept button
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Use the shell's metaModelManager to edit the concept
                  shellApp.metaModelManager.editConcept(concept);
                },
              ),
              // Delete concept button
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Delete the concept using the shell's metaModelManager
                  shellApp.metaModelManager.deleteConcept(concept);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Example of using advanced canvas visualization
class DomainCanvasExample extends StatelessWidget {
  final ShellApp shellApp;

  const DomainCanvasExample({super.key, required this.shellApp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Domain Canvas: ${shellApp.domain.code}'),
      ),
      body: const Center(
        child: MetaDomainCanvas(),
      ),
    );
  }
}

/// Main example showing how to utilize all features
void main() {
  // Create a sample domain
  final domain = _createSampleDomain();

  // Run the full-featured app
  runApp(FullFeaturedExampleApp(domain: domain));
}

/// Create a sample domain for the example
Domain _createSampleDomain() {
  final domain = Domain('SampleDomain');

  // Create a Task model
  final taskModel = Model(domain, 'TaskModel');
  domain.models.add(taskModel);

  // Create a Task concept
  final taskConcept = Concept(taskModel, 'Task');
  taskConcept.entry = true;
  taskModel.concepts.add(taskConcept);

  // Create a Project concept
  final projectConcept = Concept(taskModel, 'Project');
  projectConcept.entry = true;
  taskModel.concepts.add(projectConcept);

  // Create relationships
  taskConcept.addChild(projectConcept);
  projectConcept.addChild(taskConcept);

  return domain;
}
