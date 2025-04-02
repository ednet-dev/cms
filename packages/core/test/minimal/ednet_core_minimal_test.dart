import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('EDNet Core Domain Model Tests', () {
    test('Domain and Model creation', () {
      // Create a domain
      var domain = Domain('TestDomain');
      expect(domain.code, equals('TestDomain'));
      
      // Create a model in the domain
      var model = Model(domain, 'TestModel');
      expect(model.code, equals('TestModel'));
      expect(domain.models.length, equals(1));
    });
    
    test('Concept creation with attributes', () {
      var domain = Domain('TestDomain');
      var model = Model(domain, 'TestModel');
      
      // Create a concept in the model
      var concept = Concept(model, 'Person');
      expect(concept.code, equals('Person'));
      expect(model.concepts.length, equals(1));
      
      // Add attributes to the concept
      var nameAttr = Attribute(concept, 'name');
      nameAttr.type = Type('String');
      nameAttr.required = true;
      
      expect(concept.attributes.length, equals(1));
      expect(concept.attributes.first.code, equals('name'));
    });
    
    test('Relationships between concepts', () {
      var domain = Domain('TestDomain');
      var model = Model(domain, 'TestModel');
      
      // Create concepts
      var person = Concept(model, 'Person');
      var address = Concept(model, 'Address');
      var order = Concept(model, 'Order');
      
      // Create relationships
      var hasAddress = Parent('address', address);
      person.addParent(hasAddress);
      
      var hasOrders = Child('orders', order);
      person.addChild(hasOrders);
      
      // Validate relationships
      expect(person.parents.length, equals(1));
      expect(person.parents.first.code, equals('address'));
      expect(person.parents.first.destination, equals(address));
      
      expect(person.children.length, equals(1));
      expect(person.children.first.code, equals('orders'));
      expect(person.children.first.destination, equals(order));
    });
  });
} 