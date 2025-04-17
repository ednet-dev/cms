import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

// Mock implementations for testing
class MockMetaModelManager {
  void createConcept(Model model, String conceptName) {}
  void modifyConcept(Concept concept, Map<String, dynamic> changes) {}
  void deleteConcept(Concept concept) {}
}

class MockEnhancedThemeService extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void setAccessibilityFeature(String feature, bool enabled) {}
}

class MockBookmarkService extends ChangeNotifier {
  List<dynamic> bookmarks = [];
  void addBookmark(dynamic bookmark) {
    bookmarks.add(bookmark);
    notifyListeners();
  }
}

class MockFilterService extends ChangeNotifier {
  List<dynamic> filters = [];
  void addFilter(dynamic filter) {
    filters.add(filter);
    notifyListeners();
  }
}

void main() {
  late Domain testDomain;
  late ShellApp shellApp;

  setUp(() {
    // Create test domain
    testDomain = Domain('TestDomain');
    final model = Model(testDomain, 'TestModel');
    testDomain.models.add(model);
    final concept = Concept(model, 'TestConcept');
    model.concepts.add(concept);

    // Create shell app with default configuration
    shellApp = createDefaultEnabledShellApp(testDomain);
  });

  group('Shell Feature Integration Tests', () {
    test('Domain Model Diffing is enabled by default', () {
      expect(shellApp.hasFeature('domain_model_diffing'), isTrue);

      // Verify API is accessible
      expect(shellApp.exportDomainModelDiff, isA<Function>());
      expect(shellApp.importDomainModelDiff, isA<Function>());
      expect(shellApp.saveDomainModelDiffToFile, isA<Function>());
      expect(shellApp.getDomainModelDiffHistory, isA<Function>());
    });

    test('Meta Model Editing is enabled by default', () {
      expect(shellApp.hasFeature(ShellConfiguration.metaModelEditingFeature),
          isTrue);

      // Verify meta model manager is accessible
      expect(shellApp.metaModelManager, isNotNull);
    });

    test('Tree Navigation is enabled by default', () {
      expect(shellApp.hasFeature('tree_navigation'), isTrue);
    });

    test('Multiple Sidebar Modes are configured properly', () {
      // Should default to both modes being available
      expect(shellApp.configuration.sidebarMode, equals(SidebarMode.both));
    });

    test('Progressive Disclosure is configured properly', () {
      // Should have a default disclosure level
      expect(shellApp.configuration.defaultDisclosureLevel, isNotNull);
      expect(shellApp.currentDisclosureLevel, isNotNull);
    });

    test('Deep Linking is accessible', () {
      // Verify navigation service is available with path-based navigation
      expect(shellApp.navigateTo, isA<Function>());

      // Test basic navigation
      shellApp.navigateTo('/TestDomain/TestModel/TestConcept');
      expect(shellApp.navigationService.currentPath,
          equals('/TestDomain/TestModel/TestConcept'));
    });

    test('Development mode is enabled by default', () {
      expect(shellApp.hasFeature('development_mode'), isTrue);
    });
  });
}

/// Creates a ShellApp with all advanced features enabled by default
ShellApp createDefaultEnabledShellApp(Domain domain) {
  return ShellApp(
    domain: domain,
    configuration: ShellConfiguration(
      // Enable all features by default
      features: {
        // Core features
        'entity_editing',
        'entity_creation',

        // Advanced features
        'domain_model_diffing',
        'tree_navigation',
        ShellConfiguration.metaModelEditingFeature,
        ShellConfiguration.genericEntityFormFeature,
        ShellConfiguration.themeSwitchingFeature,
        ShellConfiguration.enhancedEntityCollectionFeature,
        'development_mode',
        'bookmarking',
        'filtering',
        'enhanced_theme',
        'deep_linking',
        'persistence',
        'semantic_pinning',
      },
      // Default to both sidebar modes
      sidebarMode: SidebarMode.both,
      // Default to standard disclosure level
      defaultDisclosureLevel: DisclosureLevel.standard,
    ),
  );
}
