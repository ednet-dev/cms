// import 'package:test/test.dart';
// import 'package:ednet_core/ednet_core.dart';
//
// void main() {
//   group('Policy System Tests', () {
//     late Domain domain;
//     late Model model;
//     late Concept personConcept;
//     late Entity person;
//     late PolicyRegistry registry;
//
//     setUp(() {
//       // Setup domain model
//       domain = Domain('TestDomain');
//       model = Model(domain, 'TestModel');
//       personConcept = Concept(model, 'Person');
//
//       // Setup attributes
//       var nameAttr = Attribute(personConcept, 'name');
//       nameAttr.type = Type('String');
//
//       var ageAttr = Attribute(personConcept, 'age');
//       ageAttr.type = Type('int');
//
//       var activeAttr = Attribute(personConcept, 'active');
//       activeAttr.type = Type('bool');
//
//       // Create entity
//       person = Entity<Entity>();
//       person.concept = personConcept;
//       person.setAttribute('name', 'John Doe');
//       person.setAttribute('age', 25);
//       person.setAttribute('active', true);
//
//       // Setup policy registry
//       registry = PolicyRegistry();
//     });
//
//     test('Attribute Policy', () {
//       // Create an attribute policy to check if a person is an adult (age >= 18)
//       var isAdultPolicy = AttributePolicy(
//         'isAdult',
//         'age',
//         (value) => value != null && value >= 18
//       );
//
//       // Register the policy
//       registry.registerPolicy('isAdult', isAdultPolicy);
//
//       // Test policy evaluation
//       expect(isAdultPolicy.evaluate(person), isTrue);
//
//       // Test with non-adult
//       person.setAttribute('age', 17);
//       expect(isAdultPolicy.evaluate(person), isFalse);
//     });
//
//     test('Composite Policy', () {
//       // Create individual policies
//       var isAdultPolicy = AttributePolicy(
//         'isAdult',
//         'age',
//         (value) => value != null && value >= 18
//       );
//
//       var isActivePolicy = AttributePolicy(
//         'isActive',
//         'active',
//         (value) => value == true
//       );
//
//       // Create a composite AND policy
//       var adultAndActivePolicy = AndPolicy([isAdultPolicy, isActivePolicy]);
//
//       // Register policies
//       registry.registerPolicy('isAdult', isAdultPolicy);
//       registry.registerPolicy('isActive', isActivePolicy);
//       registry.registerPolicy('adultAndActive', adultAndActivePolicy);
//
//       // Test combined policy
//       expect(adultAndActivePolicy.evaluate(person), isTrue);
//
//       // Test with one condition failing
//       person.setAttribute('active', false);
//       expect(adultAndActivePolicy.evaluate(person), isFalse);
//
//       // Test both conditions failing
//       person.setAttribute('age', 17);
//       expect(adultAndActivePolicy.evaluate(person), isFalse);
//     });
//
//     test('Policy Evaluator', () {
//       // Create policies
//       var isAdultPolicy = AttributePolicy(
//         'isAdult',
//         'age',
//         (value) => value != null && value >= 18
//       );
//
//       var isActivePolicy = AttributePolicy(
//         'isActive',
//         'active',
//         (value) => value == true
//       );
//
//       // Register policies
//       registry.registerPolicy('isAdult', isAdultPolicy);
//       registry.registerPolicy('isActive', isActivePolicy);
//
//       // Create evaluator
//       var evaluator = PolicyEvaluator(registry);
//
//       // Test evaluating a specific policy
//       var result = evaluator.evaluate(person, policyKey: 'isAdult');
//       expect(result.isSuccess, isTrue);
//
//       // Test evaluating all policies
//       result = evaluator.evaluate(person);
//       expect(result.isSuccess, isTrue);
//
//       // Test with failing policy
//       person.setAttribute('active', false);
//       result = evaluator.evaluate(person, policyKey: 'isActive');
//       expect(result.isSuccess, isFalse);
//     });
//   });
// }