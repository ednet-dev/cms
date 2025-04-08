import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'package:ednet_one/generated/one_application.dart';

/// Creates a fully-featured ShellApp that enables all EDNet Core features
/// with sensible defaults that follow the "everything enabled by default" philosophy
class EnhancedShellFactory {
  /// Create a fully configured ShellApp with all features enabled
  static ShellApp createFullFeaturedShell(OneApplication oneApplication) {
    // Get all domains from OneApplication
    final domains = oneApplication.groupedDomains;

    // Create a comprehensive shell configuration with all features enabled
    final shellConfig = _createEnhancedConfiguration();

    // Create ShellApp with all domains
    final shellApp = ShellApp(
      domain: domains.first, // Initial domain
      configuration: shellConfig,
      domains: domains, // Pass all domains for multi-domain support
    );

    // Register entity adapters for better visualization
    _registerEntityAdapters(shellApp, oneApplication);

    return shellApp;
  }

  /// Create an enhanced ShellConfiguration with all features enabled
  static ShellConfiguration _createEnhancedConfiguration() {
    return ShellConfiguration(
      // Set default disclosure level to intermediate for better information density
      defaultDisclosureLevel: DisclosureLevel.intermediate,

      // Material 3 theme with semantic colors
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Enable all available features
      features: {
        // Core features
        'responsive_layout',
        'semantic_pinning',
        'progressive_disclosure',

        // Visualization features
        'domain_visualization',
        'meta_model_visualization',
        'unified_visualization',

        // Navigation features
        'breadcrumb_navigation',
        'bookmark_support',
        'multi_domain_navigation',

        // Content features
        'filtering',
        'sorting',
        'searching',
        'exporting',

        // UX features
        'dark_mode',
        'accessibility',
        'keyboard_shortcuts',
        'drag_and_drop',

        // Advanced features
        'domain_model_editing',
        'code_generation',
        'entity_relationships',
      },
    );
  }

  /// Register custom entity adapters for all domains
  static void _registerEntityAdapters(
      ShellApp shellApp, OneApplication oneApplication) {
    // This would be enhanced with actual entity adapter registrations
    // based on the OneApplication domain models

    // Example registration for progressive disclosure
    shellApp.configureDisclosureLevel(
      userRole: 'user',
      defaultLevel: DisclosureLevel.basic,
    );

    shellApp.configureDisclosureLevel(
      userRole: 'admin',
      defaultLevel: DisclosureLevel.advanced,
    );

    shellApp.configureDisclosureLevel(
      userRole: 'developer',
      defaultLevel: DisclosureLevel.complete,
    );
  }
}

/// Wraps the standard ShellAppRunner with additional features
class EnhancedShellAppRunner extends StatelessWidget {
  /// The configured shell app
  final ShellApp shellApp;

  /// Constructor
  const EnhancedShellAppRunner({
    Key? key,
    required this.shellApp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDNet One',
      theme: shellApp.configuration.theme,
      // Use enhanced navigator with additional features
      home: _EnhancedNavigator(shellApp: shellApp),
    );
  }
}

/// Enhanced domain navigator with additional features like visualization
class _EnhancedNavigator extends StatefulWidget {
  final ShellApp shellApp;

  const _EnhancedNavigator({
    Key? key,
    required this.shellApp,
  }) : super(key: key);

  @override
  State<_EnhancedNavigator> createState() => _EnhancedNavigatorState();
}

class _EnhancedNavigatorState extends State<_EnhancedNavigator> {
  @override
  Widget build(BuildContext context) {
    return widget.shellApp.isMultiDomain
        ? _buildMultiDomainNavigator()
        : _buildSingleDomainNavigator();
  }

  Widget _buildMultiDomainNavigator() {
    return Scaffold(
      // Main content area with multi-domain navigation
      body: MultiDomainNavigator(
        shellApp: widget.shellApp,
        domainSelectorStyle: const DomainSelectorStyle(
          selectorType: DomainSelectorType.dropdown,
          hideDropdownUnderline: true,
        ),
      ),
      // Add floating action button for domain visualization if enabled
      floatingActionButton: widget.shellApp.hasFeature('domain_visualization')
          ? FloatingActionButton(
              onPressed: () => _showDomainVisualization(context),
              tooltip: 'Domain visualization',
              child: const Icon(Icons.account_tree),
            )
          : null,
    );
  }

  Widget _buildSingleDomainNavigator() {
    return Scaffold(
      // Main content area with domain navigation
      body: DomainNavigator(
        shellApp: widget.shellApp,
      ),
      // Add floating action button for domain visualization if enabled
      floatingActionButton: widget.shellApp.hasFeature('domain_visualization')
          ? FloatingActionButton(
              onPressed: () => _showDomainVisualization(context),
              tooltip: 'Domain visualization',
              child: const Icon(Icons.account_tree),
            )
          : null,
    );
  }

  void _showDomainVisualization(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Domain: ${widget.shellApp.domain.code}'),
          ),
          body: Center(
            child:
                Text('Domain Visualization for ${widget.shellApp.domain.code}'),
          ),
        ),
      ),
    );
  }
}
