import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

import 'mock/test_entity_base.dart';

class TestClock implements Clock {
  DateTime _now;

  TestClock(this._now);

  @override
  DateTime now() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

void main() {
  group('TimeBasedPolicy Tests', () {
    final Domain domain = Domain('Test');
    late Model model;
    late PolicyRegistry registry;
    late PolicyEvaluator evaluator;
    late TestDomain testDomain;
    late TestEntity testEntity;

    setUp(() {
      registry = PolicyRegistry();
      evaluator = PolicyEvaluator(registry);
      testDomain = TestDomain(domain);

      model = testDomain.testModel;
      testEntity = TestEntity(testDomain.testConcept);
    });

    test('TimeBasedPolicy Evaluation', () {
      var clock = TestClock(DateTime(2023, 1, 1));
      var expirationPolicy = TimeBasedPolicy(
        name: 'Expiration Policy',
        description: 'Entity must not be expired',
        timeAttributeName: 'expirationDate',
        validator: TimeValidators.isAfter(Duration.zero),
        scope: PolicyScope({'TestConcept'}),
        clock: clock,
      );

      registry.registerPolicy('expirationPolicy', expirationPolicy);

      testEntity.setAttribute('expirationDate', DateTime(2023, 1, 2));
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      clock.advance(Duration(days: 2));
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Expiration Policy');

      var withinLastWeekPolicy = TimeBasedPolicy(
        name: 'Within Last Week Policy',
        description: 'Entity must have been created within the last week',
        timeAttributeName: 'creationDate',
        validator: TimeValidators.isWithinLast(Duration(days: 7)),
        scope: PolicyScope({'TestConcept'}),
        clock: clock,
      );

      registry.registerPolicy('withinLastWeekPolicy', withinLastWeekPolicy);

      testEntity.setAttribute(
          'creationDate', clock.now().subtract(Duration(days: 3)));
      testEntity.setAttribute('expirationDate', DateTime(2023, 1, 4));
      result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      clock.advance(Duration(days: 5));
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 2);
      expect(result.violations[0].policyKey, 'Expiration Policy');
      expect(result.violations[1].policyKey, 'Within Last Week Policy');
    });
  });
}
