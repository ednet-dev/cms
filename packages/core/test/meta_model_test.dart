import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

Model createDomainModel() {
  Domain domain = Domain('CategoryQuestion');
  Model model = Model(domain, 'Link');
  assert(domain.models.length == 1);

  Concept categoryConcept = Concept(model, 'Category');
  categoryConcept.description = 'Category of web links.';
  assert(model.concepts.length == 1);
  Attribute(categoryConcept, 'name').identifier = true;
  Attribute(categoryConcept, 'description');
  assert(categoryConcept.attributes.length == 2);

  Concept webLinkConcept = Concept(model, 'WebLink');
  webLinkConcept.entry = false;
  webLinkConcept.description = 'Web links of interest.';
  assert(model.concepts.length == 2);
  Attribute(webLinkConcept, 'subject').identifier = true;
  Attribute(webLinkConcept, 'url');
  Attribute(webLinkConcept, 'description');
  assert(webLinkConcept.attributes.length == 3);

  Child categoryWebLinksNeighbor =
      Child(categoryConcept, webLinkConcept, 'webLinks');
  Parent webLinkCategoryNeighbor =
      Parent(webLinkConcept, categoryConcept, 'category');
  webLinkCategoryNeighbor.identifier = true;
  categoryWebLinksNeighbor.opposite = webLinkCategoryNeighbor;
  webLinkCategoryNeighbor.opposite = categoryWebLinksNeighbor;
  assert(categoryConcept.children.length == 1);
  assert(webLinkConcept.parents.length == 1);
  assert(categoryConcept.sourceParents.length == 1);
  assert(webLinkConcept.sourceChildren.length == 1);

  return model;
}

ModelEntries createModelData(Model model) {
  var entries = ModelEntries(model);
  Entities categories = entries.getEntry('Category');
  assert(categories.isEmpty);

  Entity dartCategory = Entity<Concept>();
  dartCategory.concept = categories.concept!;
  dartCategory.setAttribute('name', 'Dart');
  dartCategory.setAttribute('description', 'Dart Web language.');
  categories.add(dartCategory);
  assert(categories.length == 1);

  Entity html5Category = Entity<Concept>();
  html5Category.concept = categories.concept!;
  html5Category.setAttribute('name', 'HTML5');
  html5Category.setAttribute(
      'description', 'HTML5 is the ubiquitous platform for the web.');
  categories.add(html5Category);

  Entities? dartWebLinks = dartCategory.getChild('webLinks') as Entities?;
  assert(dartWebLinks != null);
  assert(dartWebLinks!.isEmpty);

  Entity dartHomeWebLink = Entity<Concept>();
  dartHomeWebLink.concept = dartWebLinks!.concept!;
  dartHomeWebLink.setAttribute('subject', 'Dart Home');
  dartHomeWebLink.setAttribute('url', 'http://www.dartlang.org/');
  dartHomeWebLink.setAttribute('description',
      'Dart brings structure to web app engineering with a new language, libraries, and tools.');
  dartHomeWebLink.setParent('category', dartCategory);
  dartWebLinks.add(dartHomeWebLink);
  assert(dartWebLinks.length == 1);
  // assert(dartHomeWebLink.getParent('category')?.getAttribute('name') == 'Dart');

  Entity tryDartWebLink = Entity<Concept>();
  tryDartWebLink.concept = dartWebLinks.concept!;
  tryDartWebLink.setAttribute('subject', 'Try Dart');
  tryDartWebLink.setAttribute('url', 'http://try.dartlang.org/');
  tryDartWebLink.setAttribute('description',
      'Try out the Dart Language from the comfort of your web browser.');
  tryDartWebLink.setParent('category', dartCategory);
  dartWebLinks.add(tryDartWebLink);
  assert(dartWebLinks.length == 2);
  // assert(tryDartWebLink.getParent('category')?.getAttribute('name') == 'Dart');
  return entries;
}

var entries;

void testModelData(Model model) {
  group('Testing Model Data:', () {
    setUp(() {
      entries = createModelData(model);
      expect(entries, isNotNull);
    });
    tearDown(() {
      entries?.clear();
      expect(entries?.isEmpty, isTrue);
    });
    test('Find Category and Web Link by Id', () {
      var categories = entries?.getEntry('Category');
      Id categoryId = Id(entries!.getConcept('Category'));
      categoryId.setAttribute('name', 'Dart');
      var dartCategory = categories?.singleWhereId(categoryId as IId<Entity>);
      expect(dartCategory, isNotNull);
      expect(dartCategory?.getAttribute('name'), equals('Dart'));
      var dartWebLinks = dartCategory?.getChild('webLinks');
      Id dartHomeId = Id(entries!.getConcept('WebLink'));
      dartHomeId.setParent('category', dartCategory as Entity);
      dartHomeId.setAttribute('subject', 'Dart Home');
      var dartHomeWebLink =
          dartWebLinks?.singleWhereId(dartHomeId as IId<Entity>);
      expect(dartHomeWebLink, isNotNull);
      expect(dartHomeWebLink?.getAttribute('subject'), equals('Dart Home'));
    });
    test('Sort Categories by Id (code not used, id is name)', () {
      var categories = entries?.getEntry('Category');
      categories!.sort();
      categories.display(
          title: 'Categories Sorted By Id (code not used, id is name)');
    });
    test('Sort Dart Web Links by Name', () {
      var categories = entries?.getEntry('Category');
      var dartCategory = categories?.firstWhereAttribute('name', 'Dart');
      expect(dartCategory, isNotNull);
      var dartWebLinks = dartCategory?.getChild('webLinks');
      dartWebLinks?.sort();
      dartWebLinks?.display(title: 'Sorted Dart Web Links');
    });
    test('New Category with Id', () {
      var categories = entries?.getEntry('Category');
      var categoryCount = categories!.length;
      var webFrameworkCategory = Entity<Concept>();
      webFrameworkCategory.concept = categories.concept!;
      webFrameworkCategory.setAttribute('name', 'Web Framework');
      expect(webFrameworkCategory, isNotNull);
      expect((webFrameworkCategory.getChild('webLinks') as Entities).length,
          equals(0));
      categories.add(webFrameworkCategory);
      expect(categories.length, equals(++categoryCount));

      categories.display(title: 'Categories Including Web Framework');
    });
    test('New WebLink No Category Error', () {
      var categories = entries?.getEntry('Category');
      var dartCategory = categories!.firstWhereAttribute('name', 'Dart');
      expect(dartCategory, isNotNull);

      var dartWebLinks = dartCategory.getChild('webLinks');
      var dartHomeWebLink = Entity<Concept>();
      dartHomeWebLink.concept = dartWebLinks!.concept!;
      expect(dartHomeWebLink, isNotNull);
      expect(dartHomeWebLink.getParent('category'), isNull);

      dartHomeWebLink.setAttribute('subject', 'Dart Home');
      dartHomeWebLink.setAttribute('url', 'http://www.dartlang.org/');
      dartHomeWebLink.setAttribute(
          'description',
          'Dart brings structure to '
              'web app engineering with a new language, libraries, and tools.');
      dartCategory.getChild('webLinks')?.add(dartHomeWebLink);
      expect(dartCategory.getChild('webLinks')?.length,
          equals(dartWebLinks.length));
      expect(dartCategory.getChild('webLinks')?.exceptions.length, equals(1));
      expect(dartCategory.getChild('webLinks')?.exceptions.toList()[0].category,
          equals('required'));
      dartCategory
          .getChild('webLinks')
          ?.exceptions
          .display(title: 'WebLink Error');
    });
    test('From Link Model to JSON', () {
      var entryConceptCode = 'Category';
      var json = entries?.fromEntryToJson(entryConceptCode);
      expect(json, isNotNull);
      entries?.displayEntryJson(entryConceptCode);
    });
  });
}

void main() {
  testModelData(createDomainModel());
}
