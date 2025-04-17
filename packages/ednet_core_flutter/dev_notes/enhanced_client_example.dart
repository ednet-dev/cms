import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
// Import our enhanced shell integration
import 'enhanced_shell_integration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create a domain model
  final domain = createSampleDomain();

  // Run with enhanced ShellApp experience
  runApp(EDNetClientApp(domain: domain));
}

/// Create a sample domain for demonstration purposes
Domain createSampleDomain() {
  final domain = Domain('ClientDomain');
  domain.description =
      'A client domain model with all features enabled by default';

  // Create a main model
  final model = Model(domain, 'Core');
  model.description = 'Core entities';
  domain.models.add(model);

  // Create concepts
  final projectConcept = Concept(model, 'Project');
  projectConcept.entry = true;
  model.concepts.add(projectConcept);

  final taskConcept = Concept(model, 'Task');
  taskConcept.entry = true;
  model.concepts.add(taskConcept);

  return domain;
}

/// Minimal client application that leverages all advanced features by default
class EDNetClientApp extends StatefulWidget {
  final Domain domain;

  const EDNetClientApp({super.key, required this.domain});

  @override
  State<EDNetClientApp> createState() => _EDNetClientAppState();
}

class _EDNetClientAppState extends State<EDNetClientApp> {
  late ShellApp shellApp;
  late EnhancedThemeService themeService;
  ThemeMode currentThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    // Create an enhanced shell with all features enabled by default
    shellApp = EnhancedShellIntegration.createEnhancedShell(
      domain: widget.domain,
      // We don't need to specify features - all are enabled by default!
      // Only specify if you need to disable something specific:
      // disabledFeatures: {'some_feature_to_disable'},
    );

    // Set up enhanced theme service
    themeService = EnhancedShellIntegration.setupEnhancedThemeService(
      shellApp,
      // Customize themes if desired
      // lightTheme: myCustomLightTheme,
      // darkTheme: myCustomDarkTheme,
    );

    // Listen for theme changes
    themeService.addListener(_handleThemeChange);
  }

  void _handleThemeChange() {
    setState(() {
      currentThemeMode = themeService.themeMode;
    });
  }

  @override
  void dispose() {
    themeService.removeListener(_handleThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a Material app with the shell
    return MaterialApp(
      title: 'EDNet Client Example',
      theme: themeService.lightTheme,
      darkTheme: themeService.darkTheme,
      themeMode: currentThemeMode,
      debugShowCheckedModeBanner: false,
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    // Create a basic scaffold with the shell app runner
    final baseApp = Scaffold(
      appBar: AppBar(
        title: const Text('EDNet Client'),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(currentThemeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: _toggleThemeMode,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: Row(
        children: [
          // The tree sidebar is automatically included because the feature is enabled
          // If sidebarMode is SidebarMode.both or SidebarMode.tree
          if (shellApp.configuration.sidebarMode == SidebarMode.tree ||
              shellApp.configuration.sidebarMode == SidebarMode.both)
            TreeArtifactSidebar(
              shellApp: shellApp,
              onArtifactSelected: (path) {
                shellApp.navigateTo(path);
              },
            ),

          // The ShellAppRunner automatically includes all enabled features
          Expanded(
            child: ShellAppRunner(
              shellApp: shellApp,
            ),
          ),
        ],
      ),
    );

    // Wrap with domain model diffing UI - automatically adds dialog and buttons
    return EnhancedShellIntegration.addDomainModelDiffingUI(
      baseApp,
      shellApp,
    );
  }

  void _toggleThemeMode() {
    final newMode =
        currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeService.setThemeMode(newMode);
  }
}

/// Example accessor extensions to make using the enhanced features even easier
extension ShellAppEnhancedAccessors on ShellApp {
  // Quick accessors for common features

  /// Shows a dialog to edit the domain model at runtime
  void showMetaModelEditor(BuildContext context) {
    if (!hasFeature(ShellConfiguration.metaModelEditingFeature)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meta model editing is not enabled')),
      );
      return;
    }

    // Implementation would use the metaModelManager to show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Meta Model Editor'),
        content: const Text('Meta model editing dialog would appear here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Shows entity manager for a concept
  void showConceptEntities(BuildContext context, String conceptCode) {
    showEntityManager(
      context,
      conceptCode,
      title: 'Manage $conceptCode',
      initialViewMode: EntityViewMode.cards,
      allowViewModeChange: true,
    );
  }
}
