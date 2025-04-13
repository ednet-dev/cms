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
            body: Builder(
              builder: (context) => DomainSelector(
                shellApp: shellApp,
                style: DomainSelectorStyle(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  selectedTextStyle:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify initial domain
      expect(shellApp.domain.code, equals('TestDomain1'));
      expect(find.text('TestDomain1'), findsOneWidget);

      // Find and tap the second domain link
      await tester.tap(find.text('TestDomain2'));
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
                Builder(
                  builder: (context) => DomainSelector(
                    shellApp: shellApp,
                    style: DomainSelectorStyle(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      selectedTextStyle:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
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

      // Find and tap the second domain link
      await tester.tap(find.text('TestDomain2'));
      await tester.pumpAndSettle();

      // Verify UI updated
      expect(find.text('Current Domain: TestDomain2'), findsOneWidget);
    });

    testWidgets('should preserve domain selection after rebuild',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => DomainSelector(
                shellApp: shellApp,
                style: DomainSelectorStyle(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  selectedTextStyle:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ),
            ),
          ),
        ),
      );

      // Select second domain
      await tester.tap(find.text('TestDomain2'));
      await tester.pumpAndSettle();

      // Verify selection
      expect(shellApp.domain.code, equals('TestDomain2'));

      // Rebuild widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => DomainSelector(
                shellApp: shellApp,
                style: DomainSelectorStyle(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  selectedTextStyle:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify selection preserved
      expect(shellApp.domain.code, equals('TestDomain2'));
      expect(find.text('TestDomain2'), findsOneWidget);
    });
  });
}
