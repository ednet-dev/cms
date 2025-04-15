import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Enhanced ShellApp Integration
///
/// This file provides factory methods to create ShellApp instances with
/// all advanced features enabled by default, making them immediately available
/// to client applications with minimal configuration.
class EnhancedShellIntegration {
  /// Create a fully-featured ShellApp with all advanced features enabled
  ///
  /// This factory automatically enables all the advanced features in ednet_core_flutter,
  /// making them available to client applications without additional configuration.
  ///
  /// @param domain The domain model to drive the shell
  /// @param disabledFeatures Optional set of features to disable (all others remain enabled)
  /// @param sidebarMode The sidebar mode to use (defaults to both classic and tree)
  /// @param defaultDisclosureLevel The default disclosure level (defaults to standard)
  /// @param useMaterial3 Whether to use Material 3 design (defaults to true)
  /// @param showThemeToggleInAppBar Whether to show theme toggle in AppBar (defaults to true)
  /// @param customAdapters Custom layout adapters for specific entity types
  /// @param theme Light theme data
  /// @param darkTheme Dark theme data
  /// @returns A ShellApp instance with all features enabled and configured
  static ShellApp createEnhancedShell({
    required Domain domain,
    Set<String>? disabledFeatures,
    Domains? domains,
    int initialDomainIndex = 0,
    SidebarMode sidebarMode = SidebarMode.both,
    DisclosureLevel defaultDisclosureLevel = DisclosureLevel.standard,
    bool useMaterial3 = true,
    bool showThemeToggleInAppBar = true,
    Map<Type, LayoutAdapter>? customAdapters,
    ThemeData? theme,
    ThemeData? darkTheme,
  }) {
    // Start with all features enabled
    final features = _getAllDefaultEnabledFeatures();

    // Remove any specifically disabled features
    if (disabledFeatures != null) {
      features.removeAll(disabledFeatures);
    }

    // Create the shell configuration with all features enabled
    final configuration = ShellConfiguration(
      features: features,
      sidebarMode: sidebarMode,
      defaultDisclosureLevel: defaultDisclosureLevel,
      useMaterial3: useMaterial3,
      showThemeToggleInAppBar: showThemeToggleInAppBar,
      customAdapters: customAdapters,
      theme: theme,
      darkTheme: darkTheme,
    );

    // Create the shell app with the enhanced configuration
    return ShellApp(
      domain: domain,
      configuration: configuration,
      domains: domains,
      initialDomainIndex: initialDomainIndex,
    );
  }

  /// Get all default enabled features
  static Set<String> _getAllDefaultEnabledFeatures() {
    return {
      // Core features
      'entity_editing',
      'entity_creation',

      // Domain model diffing
      'domain_model_diffing',

      // Navigation features
      'tree_navigation',
      'deep_linking',

      // Meta-model features
      ShellConfiguration.metaModelEditingFeature,

      // UX features
      ShellConfiguration.genericEntityFormFeature,
      ShellConfiguration.themeSwitchingFeature,
      ShellConfiguration.enhancedEntityCollectionFeature,

      // Advanced visualization
      'canvas_visualization',

      // Bookmarking and filtering
      'bookmarking',
      'filtering',

      // Theme and accessibility
      'enhanced_theme',
      'accessibility',

      // Development and persistence
      'development_mode',
      'persistence',

      // Additional advanced features
      'semantic_pinning',
      'policy_based_ui',
      'application_service',
    };
  }

  /// Set up enhanced theme service for the shell app
  ///
  /// This method initializes the enhanced theme service and connects it to the shell app,
  /// enabling advanced theme features like accessibility options.
  static EnhancedThemeService setupEnhancedThemeService(
    ShellApp shellApp, {
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    ThemeMode initialThemeMode = ThemeMode.system,
  }) {
    // Create enhanced theme service with the provided themes
    final themeService = EnhancedThemeService(
      lightTheme: lightTheme ?? ThemeData.light(useMaterial3: true),
      darkTheme: darkTheme ?? ThemeData.dark(useMaterial3: true),
      initialThemeMode: initialThemeMode,
      initialDisclosure: shellApp.currentDisclosureLevel,
    );

    return themeService;
  }

  /// Apply domain model diffing setup to a flutter app
  ///
  /// This adds UI components to interact with the domain model diffing feature.
  static Widget addDomainModelDiffingUI(
    Widget child,
    ShellApp shellApp, {
    bool showFloatingButton = true,
    bool showAppBarAction = true,
  }) {
    // Ensure domain model diffing is enabled
    if (!shellApp.hasFeature('domain_model_diffing')) {
      return child;
    }

    return DomainModelDiffingWrapper(
      shellApp: shellApp,
      child: child,
      showFloatingButton: showFloatingButton,
      showAppBarAction: showAppBarAction,
    );
  }
}

/// A widget that wraps a child with domain model diffing UI components
class DomainModelDiffingWrapper extends StatefulWidget {
  final ShellApp shellApp;
  final Widget child;
  final bool showFloatingButton;
  final bool showAppBarAction;

  const DomainModelDiffingWrapper({
    super.key,
    required this.shellApp,
    required this.child,
    this.showFloatingButton = true,
    this.showAppBarAction = true,
  });

  @override
  State<DomainModelDiffingWrapper> createState() =>
      _DomainModelDiffingWrapperState();
}

class _DomainModelDiffingWrapperState extends State<DomainModelDiffingWrapper> {
  String? currentDiff;

  @override
  Widget build(BuildContext context) {
    // If domain model diffing is not enabled, just return the child
    if (!widget.shellApp.hasFeature('domain_model_diffing')) {
      return widget.child;
    }

    // Get the scaffold from the child if available
    final childScaffold = _findScaffold(widget.child);
    if (childScaffold != null) {
      // Clone the scaffold with our additions
      return Scaffold(
        appBar: childScaffold.appBar != null
            ? _enhanceAppBar(childScaffold.appBar!)
            : null,
        body: childScaffold.body,
        floatingActionButton: widget.showFloatingButton
            ? _combinedFloatingActionButton(childScaffold.floatingActionButton)
            : childScaffold.floatingActionButton,
        drawer: childScaffold.drawer,
        endDrawer: childScaffold.endDrawer,
        bottomNavigationBar: childScaffold.bottomNavigationBar,
        backgroundColor: childScaffold.backgroundColor,
        resizeToAvoidBottomInset: childScaffold.resizeToAvoidBottomInset,
      );
    }

    // If no scaffold found, wrap the child in our own scaffold
    return Scaffold(
      body: widget.child,
      floatingActionButton: widget.showFloatingButton
          ? FloatingActionButton(
              onPressed: _showModelDiff,
              tooltip: 'Domain Model Diff',
              child: const Icon(Icons.compare_arrows),
            )
          : null,
    );
  }

  // Find a Scaffold in the widget tree
  Scaffold? _findScaffold(Widget widget) {
    if (widget is Scaffold) {
      return widget;
    }
    // In a real implementation, you would need to traverse the widget tree
    // This is a placeholder and would not actually work as-is
    return null;
  }

  // Enhance an existing AppBar with our action
  PreferredSizeWidget _enhanceAppBar(PreferredSizeWidget original) {
    if (original is AppBar && widget.showAppBarAction) {
      // Clone the AppBar with our additional action
      return AppBar(
        title: original.title,
        actions: [
          ...(original.actions ?? []),
          // Add our model diff action
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Domain Model Diff',
            onPressed: _showModelDiff,
          ),
        ],
        backgroundColor: original.backgroundColor,
        foregroundColor: original.foregroundColor,
        leading: original.leading,
        automaticallyImplyLeading: original.automaticallyImplyLeading,
        bottom: original.bottom,
      );
    }
    return original;
  }

  // Combine the original FAB with our diffing FAB
  Widget? _combinedFloatingActionButton(Widget? original) {
    if (!widget.showFloatingButton) return original;

    if (original == null) {
      return FloatingActionButton(
        onPressed: _showModelDiff,
        tooltip: 'Domain Model Diff',
        child: const Icon(Icons.compare_arrows),
      );
    }

    // In a real implementation, you would create a custom FAB layout
    // This is a placeholder returning just our FAB
    return FloatingActionButton(
      onPressed: _showModelDiff,
      tooltip: 'Domain Model Diff',
      child: const Icon(Icons.compare_arrows),
    );
  }

  // Show the model diff dialog
  void _showModelDiff() {
    // Get the current diff
    final diff =
        widget.shellApp.exportDomainModelDiff(widget.shellApp.domain.code);

    // Update state with the current diff
    setState(() {
      currentDiff = diff;
    });

    // Show the diff in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Domain Model Changes'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: Text(diff.isEmpty ? 'No changes detected' : diff),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Save the diff to a file
              final success = await widget.shellApp.saveDomainModelDiffToFile(
                widget.shellApp.domain.code,
                'model_diff_${DateTime.now().millisecondsSinceEpoch}.json',
              );

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Domain model diff saved successfully')),
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
