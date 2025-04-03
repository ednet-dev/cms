// import 'package:test/test.dart';
// import 'package:ednet_core/ednet_core.dart';
// import 'dart:math';
//
// void main() {
//   test('Simple Entity and Concept Creation', () {
//     // Create concepts
//     var model = Model(Domain('TestDomain'), 'TestModel');
//     var concept = Concept(model, 'TestConcept');
//     var attribute = Attribute(concept, 'name');
//     attribute.type = Type('String');
//
//     // Verify concept was created correctly
//     expect(concept.code, equals('TestConcept'));
//     expect(concept.attributes.length, equals(1));
//
//     // Add the concept to the model
//     model.concepts.add(concept);
//     expect(model.concepts.length, equals(1));
//   });
// }