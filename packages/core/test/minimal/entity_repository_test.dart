// import 'package:test/test.dart';
// import 'package:ednet_core/ednet_core.dart';
//
// void main() {
//   group('Entity and Repository Tests', () {
//     late Domain domain;
//     late Model model;
//     late Concept personConcept;
//
//     setUp(() {
//       domain = Domain('TestDomain');
//       model = Model(domain, 'TestModel');
//       personConcept = Concept(model, 'Person');
//
//       // Setup Person concept with attributes
//       var nameAttr = Attribute(personConcept, 'name');
//       nameAttr.type = Type('String');
//
//       var ageAttr = Attribute(personConcept, 'age');
//       ageAttr.type = Type('int');
//     });
//
//     test('Entity Creation', () {
//       // Create a person entity
//       var person = Entity<Entity>();
//       person.concept = personConcept;
//
//       // Set attributes
//       person.setAttribute('name', 'John Doe');
//       person.setAttribute('age', 30);
//
//       // Verify attribute values
//       expect(person.getAttribute('name'), equals('John Doe'));
//       expect(person.getAttribute('age'), equals(30));
//     });
//
//     test('Entities Collection', () {
//       // Create entities collection
//       var persons = personConcept.newEntities();
//
//       // Create and add entities
//       var person1 = Entity<Entity>();
//       person1.concept = personConcept;
//       person1.setAttribute('name', 'John');
//       person1.setAttribute('age', 30);
//
//       var person2 = Entity<Entity>();
//       person2.concept = personConcept;
//       person2.setAttribute('name', 'Jane');
//       person2.setAttribute('age', 28);
//
//       persons.add(person1);
//       persons.add(person2);
//
//       // Verify collection behavior
//       expect(persons.length, equals(2));
//     });
//
//     test('Repository Operations', () {
//       // Create an in-memory repository
//       var repository = InMemoryRepository<Entity>(personConcept);
//
//       // Create entities to store
//       var person1 = Entity<Entity>();
//       person1.concept = personConcept;
//       person1.setAttribute('name', 'John');
//
//       var person2 = Entity<Entity>();
//       person2.concept = personConcept;
//       person2.setAttribute('name', 'Jane');
//
//       // Add entities to repository
//       repository.add(person1);
//       repository.add(person2);
//
//       // Test finding all entities
//       var allPersons = repository.findAll();
//       expect(allPersons.length, equals(2));
//
//       // Test finding by ID
//       var foundPerson = repository.findById(person1.oid);
//       expect(foundPerson, isNotNull);
//       expect(foundPerson!.getAttribute('name'), equals('John'));
//
//       // Test query with criteria
//       var criteria = FilterCriteria<Entity>();
//       criteria.addCriterion(Criterion('name', 'Jane'));
//
//       var results = repository.findByCriteria(criteria);
//       expect(results.length, equals(1));
//       expect(results.first.getAttribute('name'), equals('Jane'));
//
//       // Test removing an entity
//       repository.remove(person1);
//       expect(repository.findAll().length, equals(1));
//     });
//   });
// }