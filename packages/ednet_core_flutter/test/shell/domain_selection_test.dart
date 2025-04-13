import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

void main() {
  late Domain domain1;
  late Domain domain2;
  late ShellApp shellApp;

  setUp(() {
    // Create test domains
    domain1 = Domain('TestDomain1');
    domain1.models.add(Model(domain1, 'Model1'));

    domain2 = Domain('TestDomain2');
    domain2.models.add(Model(domain2, 'Model2'));

    // Initialize shell app with multiple domains
    shellApp = ShellApp(
      domain: domain1,
      configuration: ShellConfiguration(
        features: {'tree_navigation'},
      ),
    );
    shellApp.initializeWithDomains([domain1, domain2]);
  });

  group('Domain Selection', () {
    testWidgets('should switch domains correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DomainSelector(
              shellApp: shellApp,
              style: const DomainSelectorStyle(
                selectorType: DomainSelectorType.dropdown,
              ),
            ),
          ),
        ),
      );

      // Verify initial domain
      expect(shellApp.domain.code, equals('TestDomain1'));
      expect(find.text('TestDomain1'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();

      // Select second domain
      await tester.tap(find.text('TestDomain2').last);
      await tester.pumpAndSettle();

      // Verify domain switched
      expect(shellApp.domain.code, equals('TestDomain2'));
    });

    testWidgets('should update UI when domain changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                DomainSelector(
                  shellApp: shellApp,
                  style: const DomainSelectorStyle(
                    selectorType: DomainSelectorType.dropdown,
                  ),
                ),
                Text('Current Domain: ${shellApp.domain.code}'),
              ],
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Current Domain: TestDomain1'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();

      // Select second domain
      await tester.tap(find.text('TestDomain2').last);
      await tester.pumpAndSettle();

      // Verify UI updated
      expect(find.text('Current Domain: TestDomain2'), findsOneWidget);
    });

    testWidgets('should preserve domain selection after rebuild',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DomainSelector(
              shellApp: shellApp,
              style: const DomainSelectorStyle(
                selectorType: DomainSelectorType.dropdown,
              ),
            ),
          ),
        ),
      );

      // Switch to second domain
      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('TestDomain2').last);
      await tester.pumpAndSettle();

      // Rebuild widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DomainSelector(
              shellApp: shellApp,
              style: const DomainSelectorStyle(
                selectorType: DomainSelectorType.dropdown,
              ),
            ),
          ),
        ),
      );

      // Verify domain selection persisted
      expect(shellApp.domain.code, equals('TestDomain2'));
      expect(find.text('TestDomain2'), findsOneWidget);
    });
  });
}
