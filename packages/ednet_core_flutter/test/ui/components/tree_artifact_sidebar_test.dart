import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

void main() {
  late ShellApp shellApp;
  late Domain testDomain;
  late Model testModel;
  late Concept testConcept;

  setUp(() {
    // Create test domain hierarchy
    testDomain = Domain('TestDomain');
    testModel = Model(testDomain, 'TestModel');
    testConcept = Concept(testModel, 'TestConcept');
    testConcept.entry = true;

    // Initialize shell app with test domain
    shellApp = ShellApp(
      domain: testDomain,
      configuration: ShellConfiguration(
        features: {'tree_navigation'},
      ),
    );
  });

  group('TreeArtifactSidebar', () {
    testWidgets('displays domain hierarchy correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TreeArtifactSidebar(
              shellApp: shellApp,
            ),
          ),
        ),
      );

      // Verify domain is displayed
      expect(find.text('TestDomain'), findsOneWidget);

      // Expand domain node
      await tester.tap(find.text('TestDomain'));
      await tester.pumpAndSettle();

      // Verify model is displayed
      expect(find.text('TestModel'), findsOneWidget);

      // Expand model node
      await tester.tap(find.text('TestModel'));
      await tester.pumpAndSettle();

      // Verify concept is displayed
      expect(find.text('TestConcept'), findsOneWidget);
    });

    testWidgets('navigates to selected artifact', (tester) async {
      String? navigatedPath;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TreeArtifactSidebar(
              shellApp: shellApp,
              onArtifactSelected: (path) => navigatedPath = path,
            ),
          ),
        ),
      );

      // Select concept
      await tester.tap(find.text('TestDomain'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('TestModel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('TestConcept'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(navigatedPath, '/TestDomain/TestModel/TestConcept');
    });

    testWidgets('shows entry and abstract badges', (tester) async {
      testConcept.entry = true;
      testConcept.abstract = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TreeArtifactSidebar(
              shellApp: shellApp,
            ),
          ),
        ),
      );

      // Expand to concept
      await tester.tap(find.text('TestDomain'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('TestModel'));
      await tester.pumpAndSettle();

      // Verify badges are shown
      expect(find.text('Entry'), findsOneWidget);
      expect(find.text('Abstract'), findsOneWidget);
    });
  });
}
