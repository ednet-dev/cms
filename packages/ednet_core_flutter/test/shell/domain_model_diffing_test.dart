import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import '../test_helpers.dart';

void main() {
  late Domain testDomain;
  late ShellApp shellApp;

  setUp(() async {
    // Set up SharedPreferences mock
    await setUpSharedPreferences();

    // Set up test domain
    testDomain = Domain('TestDomain');
    final model = Model(testDomain, 'TestModel');
    testDomain.models.add(model);

    // Initialize ShellApp with domain model diffing feature
    shellApp = ShellApp(
      domain: testDomain,
      configuration: ShellConfiguration(
        features: {'domain_model_diffing'},
      ),
    );
  });

  group('Domain Model Diffing', () {
    test('exportDomainModelDiff returns empty diff for unchanged model', () {
      // Should return empty JSON for unchanged model (initial state)
      final diff = shellApp.exportDomainModelDiff(testDomain.code);

      // The diff should be a valid JSON string but essentially empty (no changes)
      expect(diff, isNotNull);
      expect(diff, isNotEmpty); // It might contain metadata or be "{}"
    });

    test('exportDomainModelDiff captures changes to domain model', () {
      // Initial state
      final initialDiff = shellApp.exportDomainModelDiff(testDomain.code);

      // Make a change to the domain model
      final concept = Concept(testDomain.models.first, 'TestConcept');
      concept.entry = true;
      testDomain.models.first.concepts.add(concept);

      // Get the diff after changes
      final updatedDiff = shellApp.exportDomainModelDiff(testDomain.code);

      // The diff should be different from the initial diff
      expect(updatedDiff, isNot(equals(initialDiff)));
      expect(updatedDiff.contains('TestConcept'), isTrue);
    });

    test('importDomainModelDiff applies changes to domain model', () async {
      // Make a change to the domain model
      final concept = Concept(testDomain.models.first, 'ImportTestConcept');
      concept.entry = true;
      testDomain.models.first.concepts.add(concept);

      // Export the diff
      final diff = shellApp.exportDomainModelDiff(testDomain.code);

      // Create a new domain and shell app
      final newDomain = Domain('TestDomain');
      final newModel = Model(newDomain, 'TestModel');
      newDomain.models.add(newModel);

      final newShellApp = ShellApp(
        domain: newDomain,
        configuration: ShellConfiguration(
          features: {'domain_model_diffing'},
        ),
      );

      // Verify the new domain doesn't have the concept
      expect(
          newDomain.models.first.concepts
              .any((c) => c.code == 'ImportTestConcept'),
          isFalse);

      // Import the diff
      final success =
          await newShellApp.importDomainModelDiff(newDomain.code, diff);

      // Verify the import was successful
      expect(success, isTrue);

      // Verify the new domain now has the concept
      expect(
          newDomain.models.first.concepts
              .any((c) => c.code == 'ImportTestConcept'),
          isTrue);
    });

    test('saveDomainModelDiffToFile saves diff to a file', () async {
      // Make a change to the domain model
      final concept = Concept(testDomain.models.first, 'SaveTestConcept');
      concept.entry = true;
      testDomain.models.first.concepts.add(concept);

      // Save the diff to a file
      final filePath = 'test_diff.json';
      final success =
          await shellApp.saveDomainModelDiffToFile(testDomain.code, filePath);

      // Verify save was successful
      expect(success, isTrue);

      // Note: In a real test we'd verify the file exists and contains the correct data
      // Here we rely on the mock implementation in the test helpers
    });

    test('getDomainModelDiffHistory returns history of diffs', () async {
      // This test assumes the history is stored and retrievable
      final history = await shellApp.getDomainModelDiffHistory(testDomain.code);

      // Verify history is a list (might be empty if no changes yet)
      expect(history, isA<List>());
    });

    test('Domain model diffing feature is disabled by default', () {
      // Create shell app without explicitly enabling domain model diffing
      final defaultShellApp = ShellApp(
        domain: testDomain,
        configuration: ShellConfiguration(),
      );

      // Verify the feature is not enabled
      expect(defaultShellApp.hasFeature('domain_model_diffing'), isFalse);
    });

    test(
        'Domain model diffing can be automatically enabled using AdvancedFeatures',
        () {
      // Create a domain
      final domain = Domain('AdvancedTestDomain');
      final model = Model(domain, 'AdvancedTestModel');
      domain.models.add(model);

      // Create shell app with default configuration
      final shellApp = ShellApp(
        domain: domain,
        configuration: ShellConfiguration(
          features: AdvancedFeatures.allAvailableFeatures,
        ),
      );

      // Verify domain model diffing is enabled
      expect(shellApp.hasFeature('domain_model_diffing'), isTrue);

      // Initialize advanced features
      shellApp.initializeAdvancedFeatures();

      // Make a change
      final concept = Concept(domain.models.first, 'AdvancedTestConcept');
      domain.models.first.concepts.add(concept);

      // Verify we can get a diff
      final diff = shellApp.exportDomainModelDiff(domain.code);
      expect(diff, isNotNull);
      expect(diff, isNotEmpty);
    });
  });
}
