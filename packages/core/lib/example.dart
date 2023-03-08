import 'package:ednet_core/ednet_core.dart';

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

void main() {
  var model = createDomainModel();
  var entries = createModelData(model);
  print('Domain Model:${model.conceptCount}');
}
