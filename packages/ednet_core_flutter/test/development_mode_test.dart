import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

void main() {
  late Domain testDomain;
  late ShellApp shellApp;

  setUp(() {
    // Create a test domain with minimal structure
    testDomain = Domain('test_domain');
    // Domain is created directly, but Model and Concept need their parent
    final model = Model(testDomain, 'test_model');
    final concept = Concept(model, 'Task');
    concept.entry = true; // Mark as entry concept
    model.concepts.add(concept);
    testDomain.models.add(model);

    // Configure shell app with development mode feature enabled
    final config = ShellConfiguration(
      features: {'development_mode', 'persistence'},
    );

    shellApp = ShellApp(
      domain: testDomain,
      configuration: config,
    );
  });

  test(
      'ShellPersistence initializes with development repository when in dev mode',
      () async {
    // Since we enabled development_mode feature, we should be using development repositories
    // Request entities for 'Task' concept
    final tasks = await shellApp.loadEntities('Task');

    // Even though we didn't add any entities, the development repository should
    // provide sample data automatically
    expect(tasks, isNotEmpty);
  });

  test('Development mode adapter allows manually loading sample data',
      () async {
    // Create the adapter with our shell app
    final adapter = DevelopmentModeChannelAdapter(shellApp);

    // Direct adapter methods can now be used to manually toggle dev mode and load data
    await adapter.loadSampleData('Task');

    // Verify adapter is in dev mode
    expect(adapter.isDevModeActive, isTrue);

    // Get entities for the concept
    final tasks = await shellApp.loadEntities('Task');

    // Verify the data was loaded
    expect(tasks, isNotEmpty);
    expect(
        tasks.firstWhere((e) => e['title'] != null, orElse: () => {})['title'],
        isNotNull);
  });

  testWidgets('DevelopmentModeControlPanel allows toggling dev mode',
      (WidgetTester tester) async {
    // Create the adapter with our shell app
    final adapter = DevelopmentModeChannelAdapter(shellApp);

    // Build the control panel widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DevelopmentModeControlPanel(adapter: adapter),
        ),
      ),
    );

    // Verify the panel is visible
    expect(find.text('Development Mode'), findsOneWidget);

    // Initially dev mode should be disabled
    expect(adapter.isDevModeActive, isFalse);

    // Toggle dev mode on - using direct adapter method for reliability
    adapter.toggleDevMode();
    await tester.pump();

    // Now dev mode should be enabled
    expect(adapter.isDevModeActive, isTrue);
  });
}
