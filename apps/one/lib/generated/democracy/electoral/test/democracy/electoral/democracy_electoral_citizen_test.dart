// test/democracy/electoral/democracy_electoral_citizen_test.dart

import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

import '../../../lib/democracy_electoral.dart';

void testDemocracyElectoralCitizens(DemocracyDomain democracyDomain, ElectoralModel electoralModel, Citizens citizens) {
  DomainSession session;
  group('Testing Democracy.Electoral.Citizen', () {
    session = democracyDomain.newSession();
    setUp(() {
      electoralModel.init();
    });
    tearDown(() {
      electoralModel.clear();
    });

    test('Not empty model', () {
      expect(electoralModel.isEmpty, isFalse);
      expect(citizens.isEmpty, isFalse);
    });

    test('Empty model', () {
      electoralModel.clear();
      expect(electoralModel.isEmpty, isTrue);
      expect(citizens.isEmpty, isTrue);
      expect(citizens.exceptions.isEmpty, isTrue);
    });

    test('From model to JSON', () {
      final json = electoralModel.toJson();
      expect(json, isNotNull);

      print(json);
      //electoralModel.displayJson();
      //electoralModel.display();
    });

    test('From JSON to model', () {
      final json = electoralModel.toJson();
      electoralModel.clear();
      expect(electoralModel.isEmpty, isTrue);
      electoralModel.fromJson(json);
      expect(electoralModel.isEmpty, isFalse);

      electoralModel.display();
    });

    test('From model entry to JSON', () {
      final json = electoralModel.fromEntryToJson('Citizen');
      expect(json, isNotNull);

      print(json);
      //electoralModel.displayEntryJson('Citizen');
      //electoralModel.displayJson();
      //electoralModel.display();
    });

    test('From JSON to model entry', () {
      final json = electoralModel.fromEntryToJson('Citizen');
      citizens.clear();
      expect(citizens.isEmpty, isTrue);
      electoralModel.fromJsonToEntry(json);
      expect(citizens.isEmpty, isFalse);

      citizens.display(title: 'From JSON to model entry');
    });

    test('Add citizen required error', () {
      // no required attribute that is not id
    });

    test('Add citizen unique error', () {
      final citizenConcept = citizens.concept;
      var citizenCount = citizens.length;
      final citizen = Citizen(citizenConcept);
      final randomCitizen = electoralModel.citizens.random();
      citizen.citizenId = randomCitizen.citizenId;
      final added = citizens.add(citizen);
      expect(added, isFalse);
      expect(citizens.length, equals(citizenCount));
      expect(citizens.exceptions.length, greaterThan(0));

      citizens.exceptions.display(title: 'Add citizen unique error');
    });

    test('Not found citizen by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final citizen = citizens.singleWhereOid(ednetOid);
      expect(citizen, isNull);
    });

    test('Find citizen by oid', () {
      final randomCitizen = electoralModel.citizens.random();
      final citizen = citizens.singleWhereOid(randomCitizen.oid);
      expect(citizen, isNotNull);
      expect(citizen, equals(randomCitizen));
    });

    test('Find citizen by attribute id', () {
      final randomCitizen = electoralModel.citizens.random();
      final citizen = citizens.singleWhereAttributeId('citizenId', randomCitizen.citizenId);
      expect(citizen, isNotNull);
      expect(citizen!.citizenId, equals(randomCitizen.citizenId));
    });

    test('Find citizen by required attribute', () {
      // no required attribute that is not id
    });

    test('Find citizen by attribute', () {
      final randomCitizen = electoralModel.citizens.random();
      final citizen = citizens.firstWhereAttribute('firstName', randomCitizen.firstName);
      expect(citizen, isNotNull);
      expect(citizen.firstName, equals(randomCitizen.firstName));
    });

    test('Select citizens by attribute', () {
      final randomCitizen = electoralModel.citizens.random();
      final selectedCitizens = citizens.selectWhereAttribute('firstName', randomCitizen.firstName);
      expect(selectedCitizens.isEmpty, isFalse);
      for (final se in selectedCitizens) {
        expect(se.firstName, equals(randomCitizen.firstName));
      }
      //selectedCitizens.display(title: 'Select citizens by firstName');
    });

    test('Select citizens by required attribute', () {
      // no required attribute that is not id
    });

    test('Select citizens by attribute, then add', () {
      final randomCitizen = electoralModel.citizens.random();
      final selectedCitizens = citizens.selectWhereAttribute('firstName', randomCitizen.firstName);
      expect(selectedCitizens.isEmpty, isFalse);
      expect(selectedCitizens.source?.isEmpty, isFalse);
      var citizensCount = citizens.length;

      final citizen = Citizen(citizens.concept)
        ..citizenId = 'selfie'
        ..firstName = 'discount'
        ..lastName = 'walking';
      final added = selectedCitizens.add(citizen);
      expect(added, isTrue);
      expect(citizens.length, equals(++citizensCount));

      //selectedCitizens.display(title:
      //  'Select citizens by attribute, then add');
      //citizens.display(title: 'All citizens');
    });

    test('Select citizens by attribute, then remove', () {
      final randomCitizen = electoralModel.citizens.random();
      final selectedCitizens = citizens.selectWhereAttribute('firstName', randomCitizen.firstName);
      expect(selectedCitizens.isEmpty, isFalse);
      expect(selectedCitizens.source?.isEmpty, isFalse);
      var citizensCount = citizens.length;

      final removed = selectedCitizens.remove(randomCitizen);
      expect(removed, isTrue);
      expect(citizens.length, equals(--citizensCount));

      randomCitizen.display(prefix: 'removed');
      //selectedCitizens.display(title:
      //  'Select citizens by attribute, then remove');
      //citizens.display(title: 'All citizens');
    });

    test('Sort citizens', () {
      citizens.sort();

      //citizens.display(title: 'Sort citizens');
    });

    test('Order citizens', () {
      final orderedCitizens = citizens.order();
      expect(orderedCitizens.isEmpty, isFalse);
      expect(orderedCitizens.length, equals(citizens.length));
      expect(orderedCitizens.source?.isEmpty, isFalse);
      expect(orderedCitizens.source?.length, equals(citizens.length));
      expect(orderedCitizens, isNot(same(citizens)));

      //orderedCitizens.display(title: 'Order citizens');
    });

    test('Copy citizens', () {
      final copiedCitizens = citizens.copy();
      expect(copiedCitizens.isEmpty, isFalse);
      expect(copiedCitizens.length, equals(citizens.length));
      expect(copiedCitizens, isNot(same(citizens)));
      for (final e in copiedCitizens) {
        expect(e, equals(citizens.singleWhereOid(e.oid)));
      }
      for (final e in copiedCitizens) {
        expect(e, isNot(same(citizens.singleWhereId(e.id!))));
      }
      //copiedCitizens.display(title: "Copy citizens");
    });

    test('True for every citizen', () {
      // no required attribute that is not id
    });

    test('Random citizen', () {
      final citizen1 = electoralModel.citizens.random();
      expect(citizen1, isNotNull);
      final citizen2 = electoralModel.citizens.random();
      expect(citizen2, isNotNull);

      //citizen1.display(prefix: 'random1');
      //citizen2.display(prefix: 'random2');
    });

    test('Update citizen id with try', () {
      final randomCitizen = electoralModel.citizens.random();
      final beforeUpdate = randomCitizen.citizenId;
      try {
        randomCitizen.citizenId = 'distance';
      } on UpdateException {
        expect(randomCitizen.citizenId, equals(beforeUpdate));
      }
    });

    test('Update citizen id without try', () {
      final randomCitizen = electoralModel.citizens.random();
      final beforeUpdateValue = randomCitizen.citizenId;
      expect(() => randomCitizen.citizenId = 'ocean', throws);
      expect(randomCitizen.citizenId, equals(beforeUpdateValue));
    });

    test('Update citizen id with success', () {
      final randomCitizen = electoralModel.citizens.random();
      final afterUpdateEntity = randomCitizen.copy();
      final attribute = randomCitizen.concept.attributes.singleWhereCode('citizenId');
      expect(attribute?.update, isFalse);
      attribute?.update = true;
      afterUpdateEntity.citizenId = 'email';
      expect(afterUpdateEntity.citizenId, equals('email'));
      attribute?.update = false;
      final updated = citizens.update(randomCitizen, afterUpdateEntity);
      expect(updated, isTrue);

      final entity = citizens.singleWhereAttributeId('citizenId', 'email');
      expect(entity, isNotNull);
      expect(entity!.citizenId, equals('email'));

      //citizens.display('After update citizen id');
    });

    test('Update citizen non id attribute with failure', () {
      final randomCitizen = electoralModel.citizens.random();
      final afterUpdateEntity = randomCitizen.copy()..firstName = 'text';
      expect(afterUpdateEntity.firstName, equals('text'));
      // citizens.update can only be used if oid, code or id is set.
      expect(() => citizens.update(randomCitizen, afterUpdateEntity), throwsA(isA<Exception>()));
    });

    test('Copy Equality', () {
      final randomCitizen = electoralModel.citizens.random()..display(prefix: 'before copy: ');
      final randomCitizenCopy = randomCitizen.copy()..display(prefix: 'after copy: ');
      expect(randomCitizen, equals(randomCitizenCopy));
      expect(randomCitizen.oid, equals(randomCitizenCopy.oid));
      expect(randomCitizen.code, equals(randomCitizenCopy.code));
      expect(randomCitizen.citizenId, equals(randomCitizenCopy.citizenId));
      expect(randomCitizen.firstName, equals(randomCitizenCopy.firstName));
      expect(randomCitizen.lastName, equals(randomCitizenCopy.lastName));

      expect(randomCitizen.id, isNotNull);
      expect(randomCitizenCopy.id, isNotNull);
      expect(randomCitizen.id, equals(randomCitizenCopy.id));

      var idsEqual = false;
      if (randomCitizen.id == randomCitizenCopy.id) {
        idsEqual = true;
      }
      expect(idsEqual, isTrue);

      idsEqual = false;
      if (randomCitizen.id!.equals(randomCitizenCopy.id!)) {
        idsEqual = true;
      }
      expect(idsEqual, isTrue);
    });

    test('citizen action undo and redo', () {
      var citizenCount = citizens.length;
      final citizen = Citizen(citizens.concept)
        ..citizenId = 'taxi'
        ..firstName = 'picture'
        ..lastName = 'parfem';
      citizens.add(citizen);
      expect(citizens.length, equals(++citizenCount));
      citizens.remove(citizen);
      expect(citizens.length, equals(--citizenCount));

      final action = AddCommand(session, citizens, citizen)..doIt();
      expect(citizens.length, equals(++citizenCount));

      action.undo();
      expect(citizens.length, equals(--citizenCount));

      action.redo();
      expect(citizens.length, equals(++citizenCount));
    });

    test('citizen session undo and redo', () {
      var citizenCount = citizens.length;
      final citizen = Citizen(citizens.concept)
        ..citizenId = 'office'
        ..firstName = 'life'
        ..lastName = 'cup';
      citizens.add(citizen);
      expect(citizens.length, equals(++citizenCount));
      citizens.remove(citizen);
      expect(citizens.length, equals(--citizenCount));

      AddCommand(session, citizens, citizen).doIt();
      ;
      expect(citizens.length, equals(++citizenCount));

      session.past.undo();
      expect(citizens.length, equals(--citizenCount));

      session.past.redo();
      expect(citizens.length, equals(++citizenCount));
    });

    test('Citizen update undo and redo', () {
      final citizen = electoralModel.citizens.random();
      final action = SetAttributeCommand(session, citizen, 'firstName', 'wheat')..doIt();

      session.past.undo();
      expect(citizen.firstName, equals(action.before));

      session.past.redo();
      expect(citizen.firstName, equals(action.after));
    });

    test('Citizen action with multiple undos and redos', () {
      var citizenCount = citizens.length;
      final citizen1 = electoralModel.citizens.random();

      RemoveCommand(session, citizens, citizen1).doIt();
      expect(citizens.length, equals(--citizenCount));

      final citizen2 = electoralModel.citizens.random();

      RemoveCommand(session, citizens, citizen2).doIt();
      expect(citizens.length, equals(--citizenCount));

      //session.past.display();

      session.past.undo();
      expect(citizens.length, equals(++citizenCount));

      session.past.undo();
      expect(citizens.length, equals(++citizenCount));

      //session.past.display();

      session.past.redo();
      expect(citizens.length, equals(--citizenCount));

      session.past.redo();
      expect(citizens.length, equals(--citizenCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var citizenCount = citizens.length;
      final citizen1 = electoralModel.citizens.random();
      var citizen2 = electoralModel.citizens.random();
      while (citizen1 == citizen2) {
        citizen2 = electoralModel.citizens.random();
      }
      final action1 = RemoveCommand(session, citizens, citizen1);
      final action2 = RemoveCommand(session, citizens, citizen2);

      Transaction('two removes on citizens', session)
        ..add(action1)
        ..add(action2)
        ..doIt();
      citizenCount = citizenCount - 2;
      expect(citizens.length, equals(citizenCount));

      citizens.display(title: 'Transaction Done');

      session.past.undo();
      citizenCount = citizenCount + 2;
      expect(citizens.length, equals(citizenCount));

      citizens.display(title: 'Transaction Undone');

      session.past.redo();
      citizenCount = citizenCount - 2;
      expect(citizens.length, equals(citizenCount));

      citizens.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final citizenCount = citizens.length;
      final citizen1 = electoralModel.citizens.random();
      final citizen2 = citizen1;
      final action1 = RemoveCommand(session, citizens, citizen1);
      final action2 = RemoveCommand(session, citizens, citizen2);

      final transaction = Transaction(
        'two removes on citizens, with an error on the second',
        session,
      )
        ..add(action1)
        ..add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(citizens.length, equals(citizenCount));

      //citizens.display(title:'Transaction with an error');
    });

    test('Reactions to citizen actions', () {
      var citizenCount = citizens.length;

      final reaction = CitizenReaction();
      expect(reaction, isNotNull);

      democracyDomain.startCommandReaction(reaction);
      final citizen = Citizen(citizens.concept)
        ..citizenId = 'country'
        ..firstName = 'employer'
        ..lastName = 'navigation';
      citizens.add(citizen);
      expect(citizens.length, equals(++citizenCount));
      citizens.remove(citizen);
      expect(citizens.length, equals(--citizenCount));

      final session = democracyDomain.newSession();
      AddCommand(session, citizens, citizen).doIt();
      expect(citizens.length, equals(++citizenCount));
      expect(reaction.reactedOnAdd, isTrue);

      SetAttributeCommand(
        session,
        citizen,
        'firstName',
        'feeling',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue);
      democracyDomain.cancelCommandReaction(reaction);
    });
  });
}

class CitizenReaction implements ICommandReaction {
  bool reactedOnAdd = false;
  bool reactedOnUpdate = false;

  @override
  void react(ICommand action) {
    if (action is IEntitiesCommand) {
      reactedOnAdd = true;
    } else if (action is IEntityCommand) {
      reactedOnUpdate = true;
    }
  }
}

void main() {
  final repository = DemocracyElectoralRepo();
  final democracyDomain = repository.getDomainModels('Democracy') as DemocracyDomain?;
  assert(democracyDomain != null, 'DemocracyDomain is not defined');
  final electoralModel = democracyDomain!.getModelEntries('Electoral') as ElectoralModel?;
  assert(electoralModel != null, 'ElectoralModel is not defined');
  final citizens = electoralModel!.citizens;
  testDemocracyElectoralCitizens(democracyDomain, electoralModel, citizens);
}
